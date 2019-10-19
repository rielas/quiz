module Main exposing (Msg(..), init, main, subscriptions, update, view)

import Array
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Keyed as Keyed
import Html.Parser
import Html.Parser.Util
import Random


textHtml : String -> List (Html.Html msg)
textHtml t =
    case Html.Parser.run t of
        Ok nodes ->
            Html.Parser.Util.toVirtualDom nodes

        Err _ ->
            []



-- MODEL


type alias Model =
    Entry


type alias Entry =
    { description : String
    , answers : List String
    , correct : Int
    }


emptyModel =
    { description = "<p>«Это проект „Намедни. Наша эра“. События, люди, явления, определившие образ жизни, то, без чего нас невозможно представить, еще труднее&nbsp;— понять».</p><p>Когда произошло событие, о&nbsp;котором говорит Леонид Парфенов?</p><figure><div><div><div><iframe src=\"//coub.com/embed/22xuqr?muted=false&amp;autostart=false&amp;originalSize=false&amp;startWithHD=false&amp;disable_changer=true\" allowfullscreen=\"\" frameborder=\"0\" width=\"640\" height=\"360\" allow=\"autoplay\"></iframe></div></div></div></figure>"
    , answers = [ "<span>1987</span><div>13%</div>", "1989", "1991" ]
    , correct = 0
    }



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( emptyModel
    , Cmd.none
    )



-- UPDATE


type Msg
    = NoOp
    | Reset


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Reset ->
            ( emptyModel
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ class "game-wrapper" ]
        [ div
            [ class "header" ]
            [ text "1/11" ]
        , div
            [ class "card-wrapper" ]
            [ div
                [ class "html-wrapper" ]
                (textHtml model.description)
            , div
                [ class "answers" ]
                (List.map
                    (\entry ->
                        div [ class "answer" ]
                            ( textHtml entry )
                    )
                    model.answers
                )
            ]
        , div
            [ class "button-wrapper" ]
            [ text "Далее" ]
        ]
