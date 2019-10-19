module Model exposing (Model(..), Question, QuizModel, emptyModel, nextQuestion, questionsSize)


type alias QuizModel =
    { currentQuestion : Question
    , remainingQuestions : List Question
    }


type Model
    = Quiz QuizModel
    | Finish


type alias Question =
    { description : String
    , correct : String
    , incorrect : List String
    }


emptyModel =
    case questions of
        question :: rest ->
            Quiz
                { currentQuestion = question
                , remainingQuestions = rest
                }

        [] ->
            Finish


nextQuestion : Model -> Model
nextQuestion model =
    case model of
        Quiz quiz ->
            case quiz.remainingQuestions of
                question :: rest ->
                    Quiz
                        { currentQuestion = question
                        , remainingQuestions = rest
                        }

                _ ->
                    Finish

        _ ->
            Finish


questionsSize =
    List.length questions


questions =
    [ { description = "<p>«Это проект „Намедни. Наша эра“. События, люди, явления, определившие образ жизни, то, без чего нас невозможно представить, еще труднее&nbsp;— понять».</p><p>Когда произошло событие, о&nbsp;котором говорит Леонид Парфенов?</p><figure><div><div><div><iframe src=\"//coub.com/embed/22xuqr?muted=false&amp;autostart=false&amp;originalSize=false&amp;startWithHD=false&amp;disable_changer=true\" allowfullscreen=\"\" frameborder=\"0\" width=\"640\" height=\"360\" allow=\"autoplay\"></iframe></div></div></div></figure>"
      , correct = "<span>1987</span>"
      , incorrect = [ "1989", "1991" ]
      }
    , { description = "<p>В&nbsp;видео есть подсказка, но&nbsp;все&nbsp;же о&nbsp;каком мультфильме идет речь, а&nbsp;главное, когда он&nbsp;вышел?</p><figure><div><div><div><iframe src=\"//coub.com/embed/22xu83?muted=false&amp;autostart=false&amp;originalSize=false&amp;startWithHD=false&amp;disable_changer=true\" allowfullscreen=\"\" frameborder=\"0\" width=\"640\" height=\"360\" allow=\"autoplay\"></iframe></div></div></div></figure>"
      , correct = "1970"
      , incorrect = [ "1978", "1982" ]
      }
    , { description = "<p>Когда в&nbsp;СССР началась <strong>массовая продажа</strong> напитков «Фанта», «Кола» и&nbsp;«Пепси»?</p><figure><div><div><div><iframe src=\"//coub.com/embed/22xue6?muted=false&amp;autostart=false&amp;originalSize=false&amp;startWithHD=false&amp;disable_changer=true\" allowfullscreen=\"\" frameborder=\"0\" width=\"640\" height=\"360\" allow=\"autoplay\"></iframe></div></div></div></figure>"
      , correct = "Конец 70-х"
      , incorrect = [ "Начало 70-х", "Начало 90-х" ]
      }
    ]
