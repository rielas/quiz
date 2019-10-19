module View exposing (Msg(..), view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Parser
import Html.Parser.Util
import Model


textHtml : String -> List (Html.Html msg)
textHtml t =
    case Html.Parser.run t of
        Ok nodes ->
            Html.Parser.Util.toVirtualDom nodes

        Err _ ->
            []



-- UPDATE


type Msg
    = NoOp
    | Reset



-- VIEW


view : Model.Model -> Html Msg
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
                            (textHtml entry)
                    )
                    model.answers
                )
            ]
        , div
            [ class "button-wrapper" ]
            [ text "Далее" ]
        ]
