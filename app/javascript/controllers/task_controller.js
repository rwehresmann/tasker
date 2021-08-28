import { Controller } from "@stimulus/core";
import StimulusReflex from "stimulus_reflex";

export default class extends Controller {
  static targets = ["checkbox", "collapse"];
  static classes = ["incomplete"];

  connect() {
    StimulusReflex.register(this);

    $(this.collapseTarget).on("show.bs.collapse", () => {
      this.checkboxTarget.classList.add("d-none");
      this.element.classList.remove(this.incompleteClass);
    });

    $(this.collapseTarget).on("hide.bs.collapse", () => {
      this.checkboxTarget.classList.remove("d-none");
      this.element.classList.add(this.incompleteClass);
    });
  }

  destroy(event) {
    const confirmation = confirm("Are you sure?");

    if (confirmation) {
      this.stimulate("TaskReflex#destroy", event.currentTarget);
    }
  }
}
