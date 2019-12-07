module Analytics_Tests exposing (all)

import Analytics exposing (request)
import Expect
import Http
import Test exposing (..)


all : Test
all =
    describe "Check Analytics requests"
        [ test "pageview" <|
            \_ ->
                Expect.equal
                    (request Analytics.Pageview "UA-XXXXX-Y" "555" "/home")
                    ( "https://www.google-analytics.com/collect?v=1&t=pageview&tid=UA-XXXXX-Y&cid=555&dp=%2Fhome"
                    , Http.emptyBody
                    )
        ]
