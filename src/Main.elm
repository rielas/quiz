module Main exposing (init, main, subscriptions, update)

import Browser
import Debug exposing (log)
import Http
import Json.Decode as Json
import Messages as Msg
import Model
import View


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = View.view
        }


init : String -> ( Model.Model, Cmd Msg.Msg )
init address =
    ( Model.emptyModel
    , getQuestions address
    )


getQuestions : String -> Cmd Msg.Msg
getQuestions address =
    Http.get
        { url = address
        , expect =
            Http.expectJson Msg.GotModel
                (Json.list Model.questionDecoder)
        }


update : Msg.Msg -> Model.Model -> ( Model.Model, Cmd Msg.Msg )
update msg model =
    case msg of
        Msg.NoOp ->
            ( model, Cmd.none )

        Msg.Reset ->
            ( Model.emptyModel
            , Cmd.none
            )

        Msg.Quiz quiz ->
            case quiz of
                Msg.Next ->
                    ( Model.nextQuestion model, Cmd.none )

                Msg.Answer answer ->
                    ( Model.answerQuestion answer model, Cmd.none )

        Msg.GotModel questions ->
            let
                _ =
                    log "questions" questions
            in
            ( Model.setQuestions model <| Result.withDefault [] questions
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model.Model -> Sub Msg.Msg
subscriptions model =
    Sub.none
