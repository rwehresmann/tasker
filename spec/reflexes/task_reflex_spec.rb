require 'rails_helper'

RSpec.describe TaskReflex, type: :reflex do
  let(:user) { FactoryBot.create(:user) }
  let(:params) { {} }
  let(:reflex) { build_reflex(params: params, connection: { current_user: user }) }
  
  describe "#toggle" do
    subject { reflex.run(:toggle) }
    
    context "Element is checked" do
      let(:task) { FactoryBot.create(:task) }

      before do
        reflex.element.dataset.id = task.id
        reflex.element.checked = true
      end

      it "completes the task" do
        expect { subject }.to change { task.reload.complete? }.from(false).to(true)
      end

      it "broadcasts CableReady operations" do
        expect { subject }.to broadcast(
          remove: { selector: "#task_#{task.id}" }, 
          insert_adjacent_html: {
            selector: "#list_#{task.list_id} #complete-tasks",
            position: 'beforeend',
            html: kind_of(String)    
          }, 
          broadcast_to: task.list
        )
      end
    end

    context "element is unchecked" do
      let(:task) { FactoryBot.create(:task, :complete) }

      before do
        reflex.element.dataset.id = task.id
        reflex.element.checked = false
      end

      it "incompletes the task" do
        expect { subject }.to change { task.reload.complete? }.from(true).to(false)
      end

      it "broadcasts CableReady operations" do
        expect { subject }.to broadcast(
          remove: { selector: "#task_#{task.id}" }, 
          insert_adjacent_html: {
            selector: "#list_#{task.list_id} #incomplete-tasks",
            position: 'beforeend',
            html: kind_of(String)    
          }, 
          broadcast_to: task.list
        )
      end
    end
  end

  describe "#assign" do
    let(:task) { FactoryBot.create(:task) }
    let(:assignee) { FactoryBot.create(:user)}

    subject { reflex.run(:assign) }

    it "assigns an user a task" do
      reflex.element.dataset.id = task.id
      reflex.element.value = assignee.id

      expect { subject }.to change { task.reload.assignee }.from(nil).to(assignee)
      expect(subject).to morph("#task-#{task.id}-assignee").with(task.assignee_name)
    end
  end

  describe "#reorder" do
    let(:position) { 5 }
    let(:task) { FactoryBot.create(:task, position: 10) }

    subject { reflex.run(:reorder, position) }

    it "reorders a task" do
      reflex.element.dataset.id = task.id

      expect { subject }.to change { task.reload.position }.from(10).to(position)
      expect(subject).to morph(:nothing)
    end
  end

  describe "#update" do
    let(:task) { FactoryBot.create(:task, position: 10) }
    let(:params) { { task: { name: "New name" } } }

    subject { reflex.run(:update)}
    
    it "updates a task" do
      reflex.element.dataset.id = task.id

      expect { subject }.to change { task.reload.name }.to("New name")
      expect(subject).to morph("#task_#{task.id}").with(ApplicationController.render(task))
    end
  end
end
