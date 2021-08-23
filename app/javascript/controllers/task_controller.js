import { Controller } from "@stimulus/core";
import StimulusReflex from "stimulus_reflex";

export default class extends Controller {
  connect() {
    StimulusReflex.register(this);
  }
}
