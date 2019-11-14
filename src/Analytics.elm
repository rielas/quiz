module Analytics exposing (hit)

import Http
import Messages as Msg
import Url.Builder as Url


hit : String -> Cmd Msg.Msg
hit tid =
    let
        url =
            Url.absolute [ "collect" ]
                [ Url.string "v" "1"
                , Url.string "t" "pageview"
                , Url.string "tid" tid
                , Url.string "cid" "6860e328-507f-4727-b6bf-8f65ae60affe"
                , Url.string "dp" "/home/anatol/page/1"
                ]
    in
    Http.post
        { url = "https://www.google-analytics.com" ++ url
        , body = Http.emptyBody
        , expect = Http.expectWhatever Msg.Uploaded
        }
