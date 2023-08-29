// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import './bootstrap.min'
// import './custom'
// import './graph1'
// import './graph2'
// import './graph3'
// import './graph4'
// import './graph5'
// import './jquery.min'
import './left-sidebar'
import "chartkick"
import "chartkick/chart.js"
import Highcharts from "highcharts"
import './user'
window.Highcharts = Highcharts


const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
import "./controllers"



///MAC
// import "@hotwired/turbo-rails"
// import "./controllers"
//
// import { Application } from "@hotwired/stimulus"
// import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"
//
// const application = Application.start()
//
// // Configure Stimulus development experience
// application.debug = false
// window.Stimulus   = application
// const context = require.context("./controllers", true, /\.js$/)
// Stimulus.load(definitionsFromContext(context))
//
//
// export { application }
import * as bootstrap from "bootstrap"
import "chartkick"
import "chartkick/chart.js"
