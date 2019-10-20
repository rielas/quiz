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
    | Answer Int



-- VIEW


view : Model.Model -> Html Msg
view model =
    div
        [ class "game-wrapper" ]
        [ case model.state of
            Model.Quiz quiz ->
                viewQuiz quiz

            Model.Finish ->
                viewFinish model.correctAnswers
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
                , viewAnswers quiz.answered quiz.currentQuestion.answers
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


viewAnswers : Model.Answered -> List Model.Answer -> Html Msg
viewAnswers answered answers =
    div
        [ class "answers" ]
        (List.map (viewAnswer answered) answers)


viewAnswer : Model.Answered -> Model.Answer -> Html Msg
viewAnswer answered answer =
    let
        class_ =
            case answered of
                Model.Already i ->
                    if answer.correct == True then
                        " success"

                    else if answer.id == i then
                        " fail"

                    else
                        " answered"

                _ ->
                    ""

        comment =
            case answered of
                Model.Already i ->
                    if answer.id == i then
                        if answer.correct == True then
                            [ div [ class "comment" ] [ text "Правильно" ] ]

                        else
                            [ div [ class "comment" ] [ text "Ошибка" ] ]

                    else
                        []

                _ ->
                    []

        onClick_ =
            case answered of
                Model.Already _ ->
                    []

                Model.NotYet ->
                    [ onClick <| Quiz <| Answer answer.id ]
    in
    div (class ("answer" ++ class_) :: onClick_)
        ([ div [] (textHtml answer.text) ] ++ comment)


viewFinish correctAnswers =
    div []
        [ div
            []
            [ text "Конец" ]
        , div []
            [ text <|
                String.fromInt correctAnswers
                    ++ " from "
                    ++ String.fromInt Model.questionsSize
            ]
        ]
