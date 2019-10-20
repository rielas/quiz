module Model exposing (Answer, Answered(..), Model(..), Question, QuizModel, answerQuestion, emptyModel, nextQuestion, questionsSize)


type Answered
    = NotYet
    | Already Int


type alias QuizModel =
    { currentQuestion : Question
    , remainingQuestions : List Question
    , answered : Answered
    }


type Model
    = Quiz QuizModel
    | Finish


type alias Answer =
    { text : String
    , correct : Bool
    , id : Int
    }


type alias Question =
    { description : String
    , answers : List Answer
    , fail : String
    }


answerWithId : Int -> { a | text : String, correct : Bool } -> Answer
answerWithId i a =
    { text = a.text
    , correct = a.correct
    , id = i
    }


numerateAnswers question =
    let
        answers_ =
            List.indexedMap answerWithId question.answers
    in
    { description = question.description
    , answers = answers_
    , fail = question.fail
    }


emptyModel =
    case questions of
        question :: rest ->
            Quiz
                { currentQuestion = numerateAnswers question
                , remainingQuestions = List.map numerateAnswers rest
                , answered = NotYet
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
                        , answered = NotYet
                        }

                _ ->
                    Finish

        _ ->
            Finish


answerQuestion : Int -> Model -> Model
answerQuestion answer model =
    case model of
        Quiz quiz ->
            let
                quiz_ =
                    if quiz.answered == NotYet then
                        { quiz | answered = Already answer }

                    else
                        quiz
            in
            Quiz quiz_

        _ ->
            Finish


questionsSize =
    List.length questions


questions =
    [ { description = "<p>«Это проект „Намедни. Наша эра“. События, люди, явления, определившие образ жизни, то, без чего нас невозможно представить, еще труднее&nbsp;— понять».</p><p>Когда произошло событие, о&nbsp;котором говорит Леонид Парфенов?</p><figure><div><div><div><iframe src=\"//coub.com/embed/22xuqr?muted=false&amp;autostart=false&amp;originalSize=false&amp;startWithHD=false&amp;disable_changer=true\" allowfullscreen=\"\" frameborder=\"0\" width=\"640\" height=\"360\" allow=\"autoplay\"></iframe></div></div></div></figure>"
      , answers =
            [ { text = "<span>1987</span>", correct = False }
            , { text = "1989", correct = True }
            , { text = "1991", correct = False }
            ]
      , fail = "<p>Вы&nbsp;ошиблись! <a href=\"https://www.youtube.com/watch?v=cii3LSGB4bY\" target=\"_blank\" rel=\"noopener\">9&nbsp;ноября 1989 года</a> телевидение ГДР передало вот такое сообщение: «Будет открыт свободный доступ в&nbsp;Западный Берлин».</p>"
      }
    , { description = "<p>В&nbsp;видео есть подсказка, но&nbsp;все&nbsp;же о&nbsp;каком мультфильме идет речь, а&nbsp;главное, когда он&nbsp;вышел?</p><figure><div><div><div><iframe src=\"//coub.com/embed/22xu83?muted=false&amp;autostart=false&amp;originalSize=false&amp;startWithHD=false&amp;disable_changer=true\" allowfullscreen=\"\" frameborder=\"0\" width=\"640\" height=\"360\" allow=\"autoplay\"></iframe></div></div></div></figure>"
      , answers =
            [ { text = "1970", correct = True }
            , { text = "1978", correct = False }
            , { text = "1982", correct = False }
            ]
      , fail = "<p>Вот и&nbsp;нет! Режиссер Владимир Попов сделал «Трое из&nbsp;Простоквашино» <a href=\"https://www.youtube.com/watch?v=QzbrC0uQPyk\" target=\"_blank\" rel=\"noopener\">в&nbsp;1978 </a>году. Сценарий написал Эдуард Успенский. Еще один известный факт: кота Матроскина озвучивал Олег Табаков.</p>"
      }
    , { description = "<p>Когда в&nbsp;СССР началась <strong>массовая продажа</strong> напитков «Фанта», «Кола» и&nbsp;«Пепси»?</p><figure><div><div><div><iframe src=\"//coub.com/embed/22xue6?muted=false&amp;autostart=false&amp;originalSize=false&amp;startWithHD=false&amp;disable_changer=true\" allowfullscreen=\"\" frameborder=\"0\" width=\"640\" height=\"360\" allow=\"autoplay\"></iframe></div></div></div></figure>"
      , answers =
            [ { text = "Начало 70-х", correct = False }
            , { text = "Конец 70-х", correct = True }
            , { text = "Начало 90-х", correct = False }
            ]
      , fail = "<p>Нет, это довольно поздно! «Кока-кола», «Фанта» и&nbsp;«Пепси-кола» выпускались в&nbsp;цехах Очаковского завода. «Колу» продавали только на&nbsp;территории спортивных сооружений, а&nbsp;«Фанту» и&nbsp;«Пепси» люди могли купить в&nbsp;магазинах. Первые бутылки «Пепси» появились еще в&nbsp;1973 году, но&nbsp;массово все виды газировок стали продавать в&nbsp;1979-м. Тогда напиток «Пепси» появился в&nbsp;73 киосках Москвы, а&nbsp;спонсором <a href=\"https://www.youtube.com/watch?v=bM3Nr8rw8sk\" target=\"_blank\" rel=\"noopener\">Олимпиады-1980</a> в&nbsp;Москве стала Coca-Cola Company.</p>"
      }
    ]
