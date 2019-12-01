module Analytics exposing (Msg, hit)

import Http
import Url.Builder as Url


type Msg
    = Measured (Result Http.Error ())


hit : String -> String -> String -> String -> Cmd Msg
hit type_ trackingId clientId documentPath =
    let
        url =
            Url.absolute [ "collect" ]
                [ Url.string "v" "1"
                , Url.string "t" type_
                , Url.string "tid" trackingId
                , Url.string "cid" clientId
                , Url.string "dp" documentPath
                ]
    in
    Http.post
        { url = "https://www.google-analytics.com" ++ url
        , body = Http.emptyBody
        , expect = Http.expectWhatever Measured
        }
