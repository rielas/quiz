module Analytics exposing (hit)

import Http
import Messages as Msg
import Url.Builder as Url


hit : String -> String -> Cmd Msg.Msg
hit trackingId clientId =
    let
        url =
            Url.absolute [ "collect" ]
                [ Url.string "v" "1"
                , Url.string "t" "pageview"
                , Url.string "tid" trackingId
                , Url.string "cid" clientId
                , Url.string "dp" "/home/anatol/page/1"
                ]
    in
    Http.post
        { url = "https://www.google-analytics.com" ++ url
        , body = Http.emptyBody
        , expect = Http.expectWhatever Msg.Uploaded
        }
