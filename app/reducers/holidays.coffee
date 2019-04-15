import omit from 'lodash-es/omit'

export holidaysLoading = (state=false, action)->
  params = omit action, 'type'
  switch action.type
    when 'GET_HOLIDAYS'
      true
    when 'RECEIVE_HOLIDAYS'
      false
    else
      state

export holidays = (state=[], action)->
  params = omit action, 'type'
  switch action.type
    when 'GET_HOLIDAYS'
      []
    when 'RECEIVE_HOLIDAYS'
      params.holidays or []
    else
      state

export holidaysThisWeek = (state=[], action)->
  params = omit action, 'type'
  switch action.type
    when 'GET_HOLIDAYS'
      []
    when 'RECEIVE_HOLIDAYS'
      params.holidaysThisWeek or []
    else
      state

export primaryHoliday = (state=null, action)->
  params = omit action, 'type'
  switch action.type
    when 'GET_HOLIDAYS'
      null
    when 'RECEIVE_HOLIDAYS'
      params.primaryHoliday or null
    else
      state
