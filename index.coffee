import React      from 'react'
import { render } from 'react-dom'
import Gif        from '/gif'

import './styles.sass'

import format           from 'date-fns/format'
import parse            from 'date-fns/parseISO'
import addDays          from 'date-fns/addDays'
import startOfToday     from 'date-fns/startOfToday'
import isWithinInterval from 'date-fns/isWithinInterval'
import isToday          from 'date-fns/isToday'

# this relies on cloudflare pages & their geolocation service
# needs to be run locally via wrangler
holidaysHere = ->
  # if run via `npm run dev` we can skip the cloudflare stuff and serve a holiday file directly
  return require('/dist/holidays/ca_bc.json') if process.env.OFFLINE

  # else, ask cloudflare for the holiday file
  res = await fetch "/holidays"
  res.json()

thisWeekend = ->
  start: startOfToday()
  end: addDays startOfToday(), 7

holidaysThisWeekend = ->
  (h for h in await holidaysHere() when isWithinInterval parse(h.observed or h.date), thisWeekend())

nextHoliday = ->
  holidays = await holidaysThisWeekend()

  # get next serious holiday
  for h in holidays when not h.informal
    return h

  # or next informal holiday
  for h in holidays when h.informal
    return h

  # or nothing
  null

dayName = (date)->
  return 'today' if isToday date
  format date, 'EEEE'

capitalize = (str='')->
  str[0].toUpperCase() + str[1..-1].toLowerCase()

class Application extends React.Component
  constructor: (props)->
    super arguments...
    @state =
      loaded:   false
      holiday:  null

  componentDidMount: =>
    @setState {
      loaded:   true
      holiday:  await nextHoliday()
    }

  render: ->
    <div className="container">{@content()}</div>

  content: ->
    switch
      when not @state.loaded
        <h1>Ummmmm.....</h1>
      when not @state.holiday
        <>
          <h1>NO</h1>
          <Gif name={'work sad'}/>
        </>
      else
        { name, date, informal, observed } = @state.holiday
        <>
          {if informal
            <>
              <h1>Probably not <code>¯\_(ツ)_/¯</code></h1>
              <h2>even though {capitalize dayName parse date} is {name}</h2>
            </>
          else
            <>
              <h1>Yes</h1>
              {capitalize dayName parse date} is {name}
            </>
          }
          <h2>
            {if observed and not informal
              <div>(we get {dayName parse observed} off)</div>
            }
            </h2>
          <Gif name={name}/>
        </>


render <Application />, document.getElementById "application"
