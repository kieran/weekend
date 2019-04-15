import omit from 'lodash-es/omit'
import 'whatwg-fetch'

export gifLoading = (state=false, action)->
    params = omit action, 'type'
    switch action.type
      when 'GET_GIF'
        true
      when 'RECEIVE_GIF'
        false
      else
        state

export gif = (state=null, action)->
  params = omit action, 'type'
  switch action.type
    when 'GET_GIF'
      null
    when 'RECEIVE_GIF'
      params.gif
    else
      state
