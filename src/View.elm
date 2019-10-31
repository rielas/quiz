module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Parser
import Html.Parser.Util
import Messages as Msg
import Model


textHtml : String -> List (Html.Html msg)
textHtml t =
    case Html.Parser.run t of
        Ok nodes ->
            Html.Parser.Util.toVirtualDom nodes

        Err _ ->
            []


view : Model.Model -> Html Msg.Msg
view model =
    div
        [ class "game-wrapper" ]
        [ case model.state of
            Model.Start ->
                viewStart

            Model.Quiz quiz ->
                viewQuiz quiz model.questionsNumber

            Model.Finish ->
                viewFinish model.questionsNumber model.correctAnswers
        ]


viewHeader : Int -> Int -> Html Msg.Msg
viewHeader questionsNumber left =
    let
        n =
            questionsNumber - left
    in
    div
        [ class "header" ]
        [ div [ class "questions-count" ]
            [ text
                (String.fromInt n
                    ++ "/"
                    ++ String.fromInt questionsNumber
                )
            ]
        ]


viewQuiz : Model.QuizModel -> Int -> Html Msg.Msg
viewQuiz quiz questionsNumber =
    let
        sections =
            [ viewHeader questionsNumber <| List.length quiz.remainingQuestions
            , div
                [ class "card-wrapper" ]
                [ div
                    [ class "html-wrapper" ]
                    (textHtml quiz.currentQuestion.description)
                , viewAnswers quiz.answered quiz.currentQuestion
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
                                , onClick <| Msg.Quiz Msg.Next
                                ]
                                [ text "Дальше" ]
                            ]
                       ]
        )


viewAnswers : Model.Answered -> Model.Question -> Html Msg.Msg
viewAnswers answered question =
    div
        [ class "answers" ]
        (List.indexedMap (viewAnswer answered question) question.answers)


viewAnswer :
    Model.Answered
    -> Model.Question
    -> Int
    -> Model.Answer
    -> Html Msg.Msg
viewAnswer answered question id answer =
    let
        class_ =
            case answered of
                Model.Already selected ->
                    if answer.correct == True then
                        " success"

                    else if id == selected then
                        " fail"

                    else
                        " answered"

                _ ->
                    ""

        comment =
            case answered of
                Model.Already selected ->
                    if id == selected then
                        if answer.correct == True then
                            [ div [ class "comment" ] (textHtml question.success) ]

                        else
                            [ div [ class "comment" ] (textHtml question.fail) ]

                    else
                        []

                _ ->
                    []

        onClick_ =
            case answered of
                Model.Already _ ->
                    []

                Model.NotYet ->
                    [ onClick <| Msg.Quiz <| Msg.Answer id ]
    in
    div (class ("answer" ++ class_) :: onClick_)
        ([ div [ class "answer-container" ] (textHtml answer.text) ]
            ++ comment
        )


viewFinish questionsNumber correctAnswers =
    div []
        [ div
            []
            [ text "Конец" ]
        , div []
            [ text <|
                String.fromInt correctAnswers
                    ++ " from "
                    ++ String.fromInt questionsNumber
            ]
        ]


viewStart =
    div []
        [ div
            []
            [ text "Старт" ]
        ]
