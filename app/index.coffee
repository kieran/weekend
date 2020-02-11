import React    from 'react'
import ReactDOM from 'react-dom'
import Application from '/screens/application'


# find current script tag
thisScript = document.currentScript
# create new container for app to render into
container = document.createElement 'div'
# copy over data-attrs from te script tag
container.setAttribute attr.name, attr.value for attr in thisScript.attributes when /^data-.*$/.test attr.name
# inject the container div in to the dom in place of the script tag
thisScript.parentElement.replaceChild container, thisScript
# render the app into the new container div
ReactDOM.render `<Application/>`, container
