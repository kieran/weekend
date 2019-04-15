import store from '/store'
import compact from 'lodash-es/compact'

import { getHolidays } from './holidays'

import 'whatwg-fetch'

export getLocation = ->
  store.dispatch type: 'GET_LOCATION'

  fetch "https://ipapi.co/json"
  .then (response)->
    response.json()
  .then (data)->
    locale = getLocale data

    getHolidays locale

    store.dispatch
      type: 'RECEIVE_LOCATION'
      location: data
      locale: locale

getLocale = (data)->
  locale =
    country:  data.country.toLowerCase() or 'ca'
    region:   data.region_code?.toLowerCase() or 'on'
  [
    locale.country
    locale.region
  ].join '_'
