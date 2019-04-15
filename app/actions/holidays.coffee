import store from '/store'

import compact    from 'lodash-es/compact'
import addDays    from 'date-fns/add_days'
import parse      from 'date-fns/parse'
import isSameDay  from 'date-fns/is_same_day'

import { getGif } from './gif'

import 'whatwg-fetch'

export getHolidays = (locale)->
  return unless locale?
  store.dispatch type: 'GET_HOLIDAYS'

  fetch "#{locale}.json"
  .then (response)->
    response.json()
  .then (data)->

    holidaysThisWeek = getHolidaysThisWeek data
    primaryHoliday = holidaysThisWeek?[0]
    getGif primaryHoliday?.name

    store.dispatch
      type: 'RECEIVE_HOLIDAYS'
      holidays: data
      holidaysThisWeek: holidaysThisWeek
      primaryHoliday: primaryHoliday

getHolidaysThisWeek = (holidays)->
  ret = []
  today = new Date()
  for i in [0..6]
    today = addDays today, 1
    for holiday in holidays
      if isSameDay today, parse holiday.date
        ret.push holiday
  ret
