:: Importing the server library.
/+  *server
:: This imports the tile's JS file from the file system as a variable.
/=  tile-js
  /^  octs
  /;  as-octs:mimes:html
  /:  /===/app/btc/js/tile
  /|  /js/
      /~  ~
  ==
=,  format
:: This core defines the moves the application makes, as well as their types.
|%
:: +move: output effect
::
+$  move  (pair bone card)
::
+$  poke
  $%  [%launch-action [@tas path @t]]
  ==
:: +card: output move payload
::
+$  card
  $%  [%poke wire dock poke]
      [%http-response =http-event:http]
      [%connect wire binding:eyre term]
      [%diff %json json]
      [%wait wire @da]
      [%request wire request:http outbound-config:iris]
  ==
+$  state
  $%  [%0 price=@ta timer=(unit @da)]
  ==
::
--
::
|_  [bol=bowl:gall sta=state]
:: "this" is a shorthand for returning the state.
++  this  .
::
++  bound
  |=  [wir=wire success=? binding=binding:eyre]
  ^-  (quip move _this)
  [~ this]
:: The prep arm sets up the application when it first starts up or when the source code is updated.
:: We poke the launch app, which serves the tiles in the Modulo interface, with the app name, 
:: the unique path to subscribe to our app (where to send JSON to the tile) and the path the tile's served on.
:: The launch app expects window.[appNameTile] to contain the JS class for the tile (see tile/tile.js:47).
++  prep
  |=  old=(unit *)
  ^-  (quip move _this)
  ~&  "> launched"
  =/  launcha
    [%launch-action [%btc /btctile '/~btc/js/tile.js']]
  :_  this(sta *state)
  :~  [ost.bol %connect / [~ /'~btc'] %btc]
      [ost.bol %poke /btc [our.bol %launch] launcha]
      [ost.bol %request /apireq request-btc *outbound-config:iris]
  ==
::
:: peer-btctile allows other apps (or the wider internet) to subscribe to this app.
:: In this example, it sends "our.bol" (our ship's name) as a JSON string to our React.js file.
:: If you have nothing to send to the tile -- if the tile has nothing to receive from your ship --
:: you'll want to "bunt" (sending a blank with *) the JSON: delete line 62 and replace line 63 with
:: [[ost.bol %diff %json *json]~ this]
::
++  peer-btctile
  |=  pax=path
  ^-  (quip move _this)
  =/  jon=json  (pairs:enjs:format [price+n+price.sta ~])
  [[ost.bol %diff %json jon]~ this]

:: When this arm is called from this application, 
:: it sends moves to every subscriber of this application's unique path.
++  send-price-diff
  |=  price=@ta
  ^-  (list move)
  =/  jon=json
    (pairs:enjs:format [price+n+price ~])
  %+  turn  (prey:pubsub:userlib /btctile bol)
  |=  [=bone ^]
  [bone %diff %json jon]
::
++  poke-handle-http-request
  %-  (require-authorization:app ost.bol move this)
  |=  =inbound-request:eyre
  ^-  (quip move _this)
  =/  request-line  (parse-request-line url.request.inbound-request)
  =/  back-path  (flop site.request-line)
  =/  name=@t
    =/  back-path  (flop site.request-line)
    ?~  back-path
      ''
    i.back-path
  ::
  ?~  back-path
    [[ost.bol %http-response not-found:app]~ this]
  ?:  =(name 'tile')
    [[ost.bol %http-response (js-response:app tile-js)]~ this]
  [[ost.bol %http-response not-found:app]~ this]
::
++  http-response
  |=  [=wire response=client-response:iris]
  ^-  (quip move _this)
  ::  ignore all but %finished
  ?.  ?=(%finished -.response)
    [~ this]
  =/  data/(unit mime-data:iris)  full-file.response
  ?~  data
    [~ this]
  =/  ujon/(unit json)  (de-json:html q.data.u.data)
  ?~  ujon
    [~ this]
  ?>  ?=(%o -.u.ujon)
  =/  currency=json
    (~(got by p.u.ujon) 'USD')
  ?>  ?=(%o -.currency)
  =/  last-item
    (~(got by p.currency) 'last')
  ?>  ?=(%n -.last-item)
  :_  this(price.sta p.last-item)
  (send-price-diff p.last-item)


  ::  ?~  ujon
  ::     [~ this]
  ::  ?>  ?=(%o -.u.ujon)
  ::  ?:  (gth 200 status-code.response-header.response)
  ::    ~&  btc+u.ujon
  ::    ~&  btc+location
  ::    [~ this]
  ::  =/  jon/json  %-  pairs:enjs:format  :~
  ::    currently+(~(got by p.u.ujon) 'currently')
  ::    daily+(~(got by p.u.ujon) 'daily')
  ::  ==
  ::  :-  (send-tile-diff jon)
  ::  %=  this
  ::    data  jon
  ::    time  now.bol
  ::  ==
::
++  request-btc
  ^-  request:http
  =/  url  'https://blockchain.info/ticker'
  =/  hed  [['Accept' 'application/json']]~
  [%'GET' url hed *(unit octs)]
::
++  wake
  |=  [wir=wire err=(unit tang)]
  ^-  (quip move _this)
  =/  out  *outbound-config:iris
  =/  next=@da  (add now.bol ~s15)
  :_  this(timer.sta [~ next])
  :~
    [ost.bol %request /[(scot %da now.bol)] request-btc out]
    [ost.bol %wait /timer next]
  ==


--
