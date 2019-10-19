module Main exposing (init, main, subscriptions, update)

import Browser
import Model
import View


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = View.view
        }


init : () -> ( Model.Model, Cmd View.Msg )
init _ =
    ( Model.emptyModel
    , Cmd.none
    )


update : View.Msg -> Model.Model -> ( Model.Model, Cmd View.Msg )
update msg model =
    case msg of
        View.NoOp ->
            ( model, Cmd.none )

        View.Reset ->
            ( Model.emptyModel
            , Cmd.none
            )

        View.Next ->
            ( Model.nextQuestion model
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model.Model -> Sub View.Msg
subscriptions model =
    Sub.none
