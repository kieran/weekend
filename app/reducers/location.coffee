import omit from 'lodash-es/omit'

export locationLoading = (state=false, action)->
  params = omit action, 'type'
  switch action.type
    when 'GET_LOCATION'
      true
    when 'RECEIVE_LOCATION'
      false
    else
      state

export location = (state={}, action)->
  params = omit action, 'type'
  switch action.type
    when 'GET_LOCATION'
      {}
    when 'RECEIVE_LOCATION'
      params.location
    else
      state

export locale = (state=null, action)->
  params = omit action, 'type'
  switch action.type
    when 'GET_LOCATION'
      null
    when 'RECEIVE_LOCATION'
      params.locale
    else
      state
