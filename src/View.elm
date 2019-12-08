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


setDiv : String -> String -> List Html.Parser.Node -> List Html.Parser.Node
setDiv id text nodes =
    let
        text_ =
            Result.withDefault [] (Html.Parser.run text)

        f =
            \node ->
                case node of
                    Html.Parser.Element tag attrs childs ->
                        if
                            tag
                                == "div"
                                && List.member ( "id", id ) attrs
                                == True
                        then
                            Html.Parser.Element tag attrs text_

                        else
                            Html.Parser.Element tag attrs <|
                                setDiv id text childs

                    Html.Parser.Text _ ->
                        node

                    _ ->
                        node
    in
    List.map f nodes


setFields : String -> String -> String -> List (Html.Html msg)
setFields finishPage score description =
    case Html.Parser.run finishPage of
        Ok nodes ->
            setDiv "score" score nodes
                |> setDiv "description" description
                |> Html.Parser.Util.toVirtualDom

        Err _ ->
            []


view : Model.Model -> Html Msg.Msg
view model =
    div
        [ class "game-wrapper" ]
        [ case model.state of
            Model.Start ->
                viewStart model

            Model.Quiz quiz ->
                viewQuiz quiz (Model.currentQuestion model) model.questionsSize

            Model.Finish ->
                viewFinish model
        ]


viewHeader : Int -> Int -> Html Msg.Msg
viewHeader current questionsSize =
    div
        [ class "header" ]
        [ div [ class "questions-count" ]
            [ text
                (String.fromInt current
                    ++ "/"
                    ++ String.fromInt questionsSize
                )
            ]
        ]


viewQuiz : Model.QuizModel -> Int -> Int -> Html Msg.Msg
viewQuiz quiz currentQuestion questionsSize =
    let
        sections =
            [ viewHeader currentQuestion questionsSize
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


viewFinish model =
    let
        score =
            String.fromInt model.correctAnswers
                ++ "/"
                ++ String.fromInt model.questionsSize

        description =
            Maybe.map (\s -> s.description)
                (Model.getScore model.scores model.correctAnswers)
    in
    div [] <|
        setFields model.finishPage score <|
            Maybe.withDefault "" description


viewStart model =
    div []
        [ div [] (textHtml model.startPage)
        , div []
            [ button [ onClick Msg.StartQuiz ] [ text "Let's Go!" ]
            ]
        ]
