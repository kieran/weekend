import { connect } from 'react-redux'

# provide state
mapStateToProps = (state)->
  state

# provide actions
import { getLocation } from '/actions/location'
import { getHolidays } from '/actions/holidays'
import { getGif } from '/actions/gif'

mapDispatchToProps = (dispatch)->
  { getLocation, getHolidays, getGif }

export default connect mapStateToProps, mapDispatchToProps
