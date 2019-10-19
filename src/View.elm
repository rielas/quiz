module View exposing (Msg(..), view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
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
    | Next
    | Reset



-- VIEW


view : Model.Model -> Html Msg
view model =
    div
        [ class "game-wrapper" ]
        [ case model of
            Model.Quiz quiz ->
                viewQuiz quiz

            Model.Finish ->
                viewFinish
        ]


viewHeader : Int -> Html Msg
viewHeader left =
    let
        size =
            Model.questionsSize

        n =
            size - left
    in
    div
        [ class "header" ]
        [ text (String.fromInt n ++ "/" ++ String.fromInt Model.questionsSize) ]


viewQuiz : Model.QuizModel -> Html Msg
viewQuiz quiz =
    div []
        [ viewHeader <| List.length quiz.remainingQuestions
        , div
            [ class "card-wrapper" ]
            [ div
                [ class "html-wrapper" ]
                (textHtml quiz.currentQuestion.description)
            , div
                [ class "answers" ]
                (List.map
                    (\entry ->
                        div [ class "answer" ]
                            (textHtml entry)
                    )
                    quiz.currentQuestion.incorrect
                )
            ]
        , div
            [ class "button-wrapper", onClick Next ]
            [ text "Далее" ]
        ]


viewFinish =
    div []
        [ div
            []
            [ text "Конец" ]
        ]
