# iFrame Navigator lib
#
# Since main window and iframes share same window.history data, using window.back() or window.forward() may give you
# unexpected results, ex. whole page reloaded or loading page out side of an iframe. If you would like to take control
# only on certain iFrame, then use this lib in following way:
#
# var $iframe = $('iframe')
# var iNav = new IframeNavigator($iframe)
#
# iNav.forward()
# iNav.back()
# iNav.refresh()
# iNav.goToUrl('http://example.com')
#
# Copyright (c) 2013 Tomasz Borowski (http://tbprojects.pl)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
# to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial
# portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
# TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

class window.IframeNavigator
  currentPageIndex = -1
  changeType = 'new'
  pages = []

  iframe: undefined

  constructor: (iframe) ->
    that = @
    @iframe = $(iframe).first()
    @iframe.on 'load', -> onIframeLoad(that.iframe)

  back: ->
    url = pages[--currentPageIndex]
    if url
      changeType = 'back'
      @iframe.attr('src', url)
    else
      currentPageIndex++
      console.log('No pages to go backward')

  forward: ->
    url = pages[++currentPageIndex]
    if url
      changeType = 'forward'
      @iframe.attr('src', url)
    else
      currentPageIndex--
      console.log('No pages to go forward')

  refresh: ->
    url = pages[currentPageIndex]
    changeType = 'refresh'
    @iframe.attr('src', url)

  goToUrl: (url)->
    changeType = 'new'
    @iframe.attr('src', url)

  onIframeLoad = (iframe) ->
    if changeType == 'new'
      pages = pages.splice(0, ++currentPageIndex)
      pages.push(iframe.get(0).contentWindow.location.href)
    else
      changeType = 'new'