module View exposing (Msg(..), QuizMsg(..), view)

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
    | Quiz QuizMsg
    | Reset


type QuizMsg
    = Next
    | Answer



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
        [ div [ class "questions-count" ]
            [ text
                (String.fromInt n
                    ++ "/"
                    ++ String.fromInt Model.questionsSize
                )
            ]
        ]


viewQuiz : Model.QuizModel -> Html Msg
viewQuiz quiz =
    let
        sections =
            [ viewHeader <| List.length quiz.remainingQuestions
            , div
                [ class "card-wrapper" ]
                [ div
                    [ class "html-wrapper" ]
                    (textHtml quiz.currentQuestion.description)
                , viewAnswers quiz.answered quiz.currentQuestion.correct <|
                    quiz.currentQuestion.incorrect
                ]
            ]
    in
    div []
        (case quiz.answered of
            Model.NotYet ->
                sections

            _ ->
                sections
                    ++ [ div [ class "button-wrapper" ]
                            [ button
                                [ class "button"
                                , onClick <| Quiz Next
                                ]
                                [ text "Дальше" ]
                            ]
                       ]
        )


viewAnswers : Model.Answered -> String -> List String -> Html Msg
viewAnswers answered correct incorrect =
    div
        [ class "answers" ]
        (List.map
            (viewAnswer answered)
            (correct :: incorrect)
        )


viewAnswer : Model.Answered -> String -> Html Msg
viewAnswer answered answer =
    let
        class_ =
            "answer"
                ++ (case answered of
                        Model.Success ->
                            " success"

                        Model.Fail ->
                            " fail"

                        _ ->
                            ""
                   )
    in
    div [ class class_, onClick <| Quiz Answer ] [ div [] (textHtml answer) ]


viewFinish =
    div []
        [ div
            []
            [ text "Конец" ]
        ]
