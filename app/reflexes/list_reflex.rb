class ListReflex < StimulusReflex::Reflex
  def create_task
    list = element.signed[:list_id]
    @new_task = list.tasks.create(task_params.merge(creator: connection.current_user))
    
    if @new_task.persisted?
      cable_ready[ListChannel].insert_adjacent_html(
        selector: "#list_#{list.id} #incomplete-tasks",
        position: 'beforeend',
        html: render_task(@new_task),
      )
      .add_css_class(
        selector: "#list_#{list.id} #no-tasks",
        name: 'd-none'
      )
      .broadcast_to(list)

      @new_task = Task.new
    end
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

  def task_params
    params.require(:task).permit(:name)
  end
end
