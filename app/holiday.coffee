import parse            from 'date-fns/parseISO'
import addDays          from 'date-fns/addDays'
import isWithinInterval from 'date-fns/isWithinInterval'

import { get } from 'axios'

export default \
class Holiday
  constructor: ({@date, @name, @informal, @observed, @regions=[]})->
    @date = parse @date if 'string' is typeof @date

  isWithinInterval: (interval)->
    isWithinInterval @date, interval

  @thisWeek: (locale)->
    now = new Date
    interval = start: now, end: addDays now, 7
    { data: holidays } = await get "#{locale}.json"
    days = (new Holiday(h) for h in holidays)
    (d for d in days when d.isWithinInterval interval)

  @next: (locale)->
    holidays = await @thisWeek locale

    # get next serious holiday
    return h for h in holidays when not h.informal
    # or next informal holiday
    return h for h in holidays when h.informal
    # or nothing
    null
