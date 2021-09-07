class TaskReflex < StimulusReflex::Reflex
  before_reflex :find_task

  def toggle
    if element.checked
      @task.update(completed_at: Time.current, completer: connection.current_user)
    else
      @task.update(completed_at: nil, completer: nil)
    end

    cable_ready[ListChannel]
      .remove(selector: "#task_#{@task.id}")
      .insert_adjacent_html(
        selector: "#list_#{@task.list_id} #{element.checked ? '#complete-tasks' : '#incomplete-tasks'}",
        position: 'beforeend',
        html: render_task(@task)
      )
      .broadcast_to(@task.list)
  end

  def destroy
    @task.destroy

    cable_ready[ListChannel]
      .remove(selector: "#task_#{@task.id}")
      .broadcast_to(@task.list)

    if @task.list.tasks.empty?
      cable_ready[ListChannel]
      .remove_css_class(
        selector: "#list_#{@task.list_id} #no-tasks",
        name: 'd-none'
      )
      .broadcast_to(@task.list)
    end
  end

  def reorder(position)
    @task.insert_at(position)
    morph :nothing
  end

  def assign
    @task.update(assignee_id: element.value)
    morph "#task-#{@task.id}-assignee", @task.assignee_name
  end

  def update
    @task.update(task_params)
    morph "#task_#{@task.id}", render_task(@task)
  end

  private

  def render_task(task)  
    CommentsController.render(
      partial: 'tasks/task',
      locals: {
        task: task,
        team: connection.current_user.team
      }
    )
  end

  def find_task
    @task = GlobalID::Locator.locate_signed(element.dataset.id)
  end

  def task_params
    params.require(:task).permit(:name)
  end
end
