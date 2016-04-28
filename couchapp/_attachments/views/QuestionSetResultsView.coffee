$ = require 'jquery'
Backbone = require 'backbone'
Backbone.$  = $
_ = require 'underscore'

DataTables = require('datatables.net')(window,$)
moment = require 'moment'
Mathjs = require 'mathjs'

FileSaver = require 'filesaverjs'

QuestionSet = require '../models/QuestionSet'
ResultsView = require './ResultsView'

class QuestionSetResultsView extends Backbone.View
  el: '#content'

  render: =>
    console.debug "ZZZ"
    @$el.html "
      <style>
        .result{
          font-weight: bold;
        }
      </style>
      <div id='results' height='50%'>
        <div id='filters'>
          <h3>Filters</h3>
          Start Date <input id='startDate' type='date' value='#{@startDate}'></input>
          End Date <input id='endDate' type='date' value='#{@endDate}'></input>
          <br/>
          Row Must Include: <input style='text-transform:uppercase' id='rowMustInclude'></input>
          <button id='apply'>Apply</button><span id='applyStatus'></span>
        </div>
        <div>Original Results: <span id='numberTotalResults'></span></div>
        <div>Filtered Results: <span id='numberFilteredResults'></span></div>
        <div id='resultsTable'>
        </div>
      </div>
    "
    @queryResults
      startDate: @startDate
      endDate: @endDate
      error: (error) -> console.error error
      success: (@databaseResults) =>
        @renderResults(@databaseResults)

  queryResults: (options) =>
    @questionSet.fetchResultsForDates
      startDate: @startDate
      endDate: @endDate
      success: (@databaseResults) =>
        options.success(@databaseResults)

  filterResults: (results) =>
    return results unless @rowMustInclude
    # Filter results
    results = _(results).filter (row) =>
      passesRowIncludesFilter = true
      if @rowMustInclude?
        passesRowIncludesFilter = _(row.value).find (column) =>
          _(column).isString() and column.indexOf(@rowMustInclude) > -1

      return passesRowIncludesFilter

  renderResults: (results) =>
    $("#numberTotalResults").html @databaseResults.length
    $("#numberFilteredResults").html if @filteredResults? then @filteredResults.length else @databaseResults.length

    @resultsView = new ResultsView() unless @resultsView
    @resultsView.csvName = "#{@questionSet.name()}-#{$('#startDate').val()}-#{$('#endDate').val()}#{if @rowMustInclude then "-#{@rowMustInclude}" else ""}.csv"
    @resultsView.setElement(@$el.find("#resultsTable"))
    @resultsView.results = results
    @resultsView.questionSet = new QuestionSet {_id: "TUSOMETEACHER"}
    @resultsView.questionSet.fetch
      error: (error) -> console.error error
      success: () =>
        @resultsView.render()

  applyFiltersAndRender: (resultsToFilter) =>
    @filteredResults = @filterResults(resultsToFilter)
    @renderResults(@filteredResults)

  apply: =>
    @rowMustInclude = $("#rowMustInclude").val().toUpperCase()
    if @rowMustInclude is "" then @rowMustInclude = null
    startDate = $("#startDate").val()
    endDate = $("#endDate").val()
    if startDate isnt @startDate or endDate isnt @endDate
      @queryResults
        startDate: startDate
        endDate: endDate
        error: (error) -> console.error error
        success: (@filteredResults) =>
          @applyFiltersAndRender(@filteredResults)
    else
      @applyFiltersAndRender(@databaseResults)
     
  events:
    "click #apply": "apply"

module.exports = QuestionSetResultsView