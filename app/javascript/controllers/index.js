// Load all the controllers within this directory and all subdirectories. 
// Controller files must be named *_controller.js.

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"
import StimulusReflex from 'stimulus_reflex'
import consumer from '../channels/consumer'
import Radiolabel from 'radiolabel'

const application = Application.start()
const context = require.context("controllers", true, /_controller\.js$/)
application.load(definitionsFromContext(context))
application.consumer = consumer
StimulusReflex.initialize(application, { isolate: true })

// Uncomment below to see the visual radiolabel inspector in your page.  
//application.register('radiolabel', Radiolabel)
