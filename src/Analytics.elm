module Analytics exposing (Msg, pageview, suite)

import Expect
import Http
import Test exposing (..)
import Url.Builder as Url


type Msg
    = Measured (Result Http.Error ())


type HitType
    = Pageview
    | Screenview
    | Event
    | Transaction
    | Item
    | Social
    | Exception
    | Timing


toString : HitType -> String
toString hitType =
    case hitType of
        Pageview ->
            "pageview"

        Screenview ->
            "screenview"

        Event ->
            "event"

        Transaction ->
            "transaction"

        Item ->
            "item"

        Social ->
            "social"

        Exception ->
            "exception"

        Timing ->
            "timing"


request : HitType -> String -> String -> String -> ( String, Http.Body )
request type_ trackingId clientId documentPath =
    let
        url =
            Url.absolute [ "collect" ]
                [ Url.string "v" "1"
                , Url.string "t" <| toString type_
                , Url.string "tid" trackingId
                , Url.string "cid" clientId
                , Url.string "dp" documentPath
                ]
    in
    ( "https://www.google-analytics.com" ++ url, Http.emptyBody )


hit : ( String, Http.Body ) -> Cmd Msg
hit ( url, body ) =
    Http.post
        { url = url
        , body = body
        , expect = Http.expectWhatever Measured
        }


pageview : String -> String -> String -> Cmd Msg
pageview trackingId clientId documentPath =
    request Pageview trackingId clientId documentPath |> hit


suite : Test
suite =
    describe "Check Analytics requests"
        [ test "pageview" <|
            \_ ->
                Expect.equal
                    (request Pageview "UA-XXXXX-Y" "555" "/home")
                    ( "https://www.google-analytics.com/collect?v=1&t=pageview&tid=UA-XXXXX-Y&cid=555&dp=%2Fhome"
                    , Http.emptyBody
                    )
        ]
