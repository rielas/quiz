module Model exposing
    ( Answer
    , Answered(..)
    , Model
    , Question
    , QuizModel
    , Settings
    , State(..)
    , answerQuestion
    , currentQuestion
    , emptyModel
    , getScore
    , nextQuestion
    , settingsDecoder
    , startQuiz
    )

import Array
import Json.Decode as Json
import List.Extra


type Answered
    = NotYet
    | Already Int


type alias QuizModel =
    { currentQuestion : Question
    , answered : Answered
    }


type State
    = Start
    | Quiz QuizModel
    | Finish


type alias Model =
    { state : State
    , correctAnswers : Int
    , questionsSize : Int
    , startPage : String
    , finishPage : String
    , remainingQuestions : List Question
    , scores : List Score
    , trackingId : String
    , clientId : String
    }


type alias Settings =
    { questions : List Question
    , startPage : String
    , finishPage : String
    , scores : List Score
    }


type alias Answer =
    { text : String
    , correct : Bool
    }


type alias Question =
    { description : String
    , answers : List Answer
    , fail : String
    , success : String
    }


type alias Score =
    { min : Int
    , description : String
    }


startQuiz : Model -> Model
startQuiz model =
    let
        size =
            List.length model.remainingQuestions
    in
    case model.remainingQuestions of
        question :: rest ->
            { model
                | state =
                    Quiz
                        { currentQuestion = question
                        , answered = NotYet
                        }
                , remainingQuestions = rest
                , questionsSize = size
            }

        [] ->
            { model | state = Finish }


emptyModel : String -> String -> Model
emptyModel trackingId clientId =
    { state = Start
    , correctAnswers = 0
    , questionsSize = 0
    , startPage = startPage_
    , finishPage = finishPage_
    , remainingQuestions = questions_
    , scores = scores_
    , trackingId = trackingId
    , clientId = clientId
    }


nextQuestion : Model -> Model
nextQuestion model =
    case model.remainingQuestions of
        question :: rest ->
            { model
                | state =
                    Quiz
                        { currentQuestion = question
                        , answered = NotYet
                        }
                , remainingQuestions = rest
            }

        _ ->
            { model | state = Finish }


currentQuestion : Model -> Int
currentQuestion model =
    model.questionsSize - List.length model.remainingQuestions


isCorrect id quiz =
    let
        array =
            Array.fromList quiz.currentQuestion.answers

        answer =
            Array.get id array
    in
    Maybe.withDefault False <| Maybe.map (\a -> a.correct) answer


answerQuestion : Int -> Model -> Model
answerQuestion id model =
    let
        ( state_, correct ) =
            case model.state of
                Quiz quiz ->
                    let
                        quiz_ =
                            if quiz.answered == NotYet then
                                { quiz | answered = Already id }

                            else
                                quiz

                        correct_ =
                            isCorrect id quiz
                    in
                    ( Quiz quiz_, correct_ )

                _ ->
                    ( Finish, False )

        correctAnswers =
            if correct == True then
                model.correctAnswers + 1

            else
                model.correctAnswers
    in
    { model | state = state_, correctAnswers = correctAnswers }


getScore : List Score -> Int -> Maybe Score
getScore scores points =
    let
        sorted =
            List.sortBy .min scores

        lessorequal =
            List.Extra.takeWhile (\score -> score.min <= points) sorted
    in
    List.Extra.last lessorequal


answerDecoder : Json.Decoder Answer
answerDecoder =
    Json.map2 Answer
        (Json.field "text" Json.string)
        (Json.field "correct" Json.bool)


questionDecoder : Json.Decoder Question
questionDecoder =
    Json.map4 Question
        (Json.field "description" Json.string)
        (Json.field "answers" (Json.list answerDecoder))
        (Json.field "fail" Json.string)
        (Json.field "success" Json.string)


scoreDecoder : Json.Decoder Score
scoreDecoder =
    Json.map2 Score
        (Json.field "min" Json.int)
        (Json.field "description" Json.string)


settingsDecoder : Json.Decoder Settings
settingsDecoder =
    Json.map4 Settings
        (Json.field "questions" <| Json.list questionDecoder)
        (Json.field "startPage" Json.string)
        (Json.field "finishPage" Json.string)
        (Json.field "scores" <| Json.list scoreDecoder)


questions_ : List Question
questions_ =
    [ { description = "<p>«Это проект „Намедни. Наша эра“. События, люди, явления, определившие образ жизни, то, без чего нас невозможно представить, еще труднее&nbsp;— понять».</p><p>Когда произошло событие, о&nbsp;котором говорит Леонид Парфенов?</p><figure><div><div><div><iframe src=\"//coub.com/embed/22xuqr?muted=false&amp;autostart=false&amp;originalSize=false&amp;startWithHD=false&amp;disable_changer=true\" allowfullscreen=\"\" frameborder=\"0\" width=\"100%\" height=\"300\" allow=\"autoplay\"></iframe></div></div></div></figure>"
      , answers =
            [ { text = "<span>1987</span>"
              , correct = False
              }
            , { text = "1989"
              , correct = True
              }
            , { text = "1991"
              , correct = False
              }
            ]
      , fail = "<p>Вы&nbsp;ошиблись! <a href=\"https://www.youtube.com/watch?v=cii3LSGB4bY\" target=\"_blank\" rel=\"noopener\">9&nbsp;ноября 1989 года</a> телевидение ГДР передало вот такое сообщение: «Будет открыт свободный доступ в&nbsp;Западный Берлин».</p>"
      , success = "<p>Правильно! <a href=\"https://www.youtube.com/watch?v=cii3LSGB4bY\" target=\"_blank\" rel=\"noopener\">9&nbsp;ноября 1989 года</a> телевидение ГДР передало вот такое сообщение: «Будет открыт свободный доступ в&nbsp;Западный Берлин».</p>"
      }
    , { description = "<p>В&nbsp;видео есть подсказка, но&nbsp;все&nbsp;же о&nbsp;каком мультфильме идет речь, а&nbsp;главное, когда он&nbsp;вышел?</p><figure><div><div><div><iframe src=\"//coub.com/embed/22xu83?muted=false&amp;autostart=false&amp;originalSize=false&amp;startWithHD=false&amp;disable_changer=true\" allowfullscreen=\"\" frameborder=\"0\" width=\"100%\" height=\"300\" allow=\"autoplay\"></iframe></div></div></div></figure>"
      , answers =
            [ { text = "1970"
              , correct = False
              }
            , { text = "1978"
              , correct = True
              }
            , { text = "1982"
              , correct = False
              }
            ]
      , fail = "<p>Вот и&nbsp;нет! Режиссер Владимир Попов сделал «Трое из&nbsp;Простоквашино» <a href=\"https://www.youtube.com/watch?v=QzbrC0uQPyk\" target=\"_blank\" rel=\"noopener\">в&nbsp;1978 </a>году. Сценарий написал Эдуард Успенский. Еще один известный факт: кота Матроскина озвучивал Олег Табаков.</p>"
      , success = "<p>Отлично! Режиссер Владимир Попов сделал «Трое из&nbsp;Простоквашино» <a href=\"https://www.youtube.com/watch?v=QzbrC0uQPyk\" target=\"_blank\" rel=\"noopener\">в&nbsp;1978 году.</a> Сценарий написал Эдуард Успенский. Еще один известный факт: кота Матроскина озвучивал Олег Табаков.</p>"
      }
    , { description = "<p>Когда в&nbsp;СССР началась <strong>массовая продажа</strong> напитков «Фанта», «Кола» и&nbsp;«Пепси»?</p><figure><div><div><div><iframe src=\"//coub.com/embed/22xue6?muted=false&amp;autostart=false&amp;originalSize=false&amp;startWithHD=false&amp;disable_changer=true\" allowfullscreen=\"\" frameborder=\"0\" width=\"100%\" height=\"300\" allow=\"autoplay\"></iframe></div></div></div></figure>"
      , answers =
            [ { text = "Начало 70-х"
              , correct = False
              }
            , { text = "Конец 70-х"
              , correct = True
              }
            , { text = "Начало 90-х"
              , correct = False
              }
            ]
      , fail = "<p>Нет, это довольно поздно! «Кока-кола», «Фанта» и&nbsp;«Пепси-кола» выпускались в&nbsp;цехах Очаковского завода. «Колу» продавали только на&nbsp;территории спортивных сооружений, а&nbsp;«Фанту» и&nbsp;«Пепси» люди могли купить в&nbsp;магазинах. Первые бутылки «Пепси» появились еще в&nbsp;1973 году, но&nbsp;массово все виды газировок стали продавать в&nbsp;1979-м. Тогда напиток «Пепси» появился в&nbsp;73 киосках Москвы, а&nbsp;спонсором <a href=\"https://www.youtube.com/watch?v=bM3Nr8rw8sk\" target=\"_blank\" rel=\"noopener\">Олимпиады-1980</a> в&nbsp;Москве стала Coca-Cola Company.</p>"
      , success = "<p>Верно! «Кока-кола», «Фанта» и&nbsp;«Пепси-кола» выпускались в&nbsp;цехах Очаковского завода. «Колу» продавали только на&nbsp;территории спортивных сооружений, а&nbsp;«Фанту» и&nbsp;«Пепси» люди могли купить в&nbsp;магазинах. Первые бутылки «Пепси» появились еще в&nbsp;1973 году, но&nbsp;массово все виды газировок стали продавать в&nbsp;1979-м. Тогда напиток «Пепси» появился в&nbsp;73 киосках Москвы, а&nbsp;спонсором <a href=\"https://www.youtube.com/watch?v=bM3Nr8rw8sk\" target=\"_blank\" rel=\"noopener\">Олимпиады-1980</a> в&nbsp;Москве стала Coca-Cola Company.</p>"
      }
    , { description = "<p>Карибский кризис. Помните, когда он&nbsp;произошел?</p><figure><div><div><div><iframe src=\"//coub.com/embed/22xtla?muted=false&amp;autostart=false&amp;originalSize=false&amp;startWithHD=false&amp;disable_changer=true\" allowfullscreen=\"\" frameborder=\"0\" width=\"100%\" height=\"300\" allow=\"autoplay\"></iframe></div></div></div></figure>"
      , answers =
            [ { text = "Хм, в 1966-м?"
              , correct = False
              }
            , { text = "Хм, в 1962-м?"
              , correct = True
              }
            , { text = "Хм, в 1958-м?"
              , correct = False
              }
            ]
      , fail = "<p>Нет! США разместили ядерное оружие в&nbsp;Турции в&nbsp;1961 году, а&nbsp;Карибский кризис случился <a href=\"https://www.youtube.com/watch?v=9EJ5DTc1Xlg\" target=\"_blank\" rel=\"noopener\">в&nbsp;1962</a> году, когда СССР тайно разместил свои вооруженные силы на&nbsp;Кубе.</p>"
      , success = "<p>Верно! США разместили ядерное оружие в&nbsp;Турции в&nbsp;1961 году, а&nbsp;Карибский кризис случился <a href=\"https://www.youtube.com/watch?v=9EJ5DTc1Xlg\" target=\"_blank\" rel=\"noopener\">в&nbsp;1962</a> году, когда СССР тайно разместил свои вооруженные силы на&nbsp;Кубе.</p>"
      }
    ]


scores_ : List Score
scores_ =
    [ { min = 0
      , description = "<div class=\"result\">Миллениал!</div><div class=\"desc\">Вы&nbsp;что-то слышали о&nbsp;событиях второй половины XX&nbsp;века</div>"
      }
    , { min = 1
      , description = "<div class=\"result\">Поколение X</div><div class=\"desc\">Вы знаете, что происходило во второй половине XX века</div>"
      }
    , { min = 3
      , description = "<div class=\"result\">Леонид Парфенов!</div><div class=\"desc\">Вы&nbsp;смотрели все выпуски программы «Намедни»</div>"
      }
    ]


startPage_ =
    "<h1>Когда в СССР появилась «Пепси»? А когда произошло падение Берлинской стены?<span> <!-- -->Проверим, смотрели ли вы программу «Намедни» </span></h1>\n    <div class=\"date\"><time>09:00, 17 октября 2019</time></div>\n    <p>Леонид Парфенов заявил, что ему больше не принадлежит бренд «Намедни». Это произошло по требованию канала НТВ. А вы смотрели старые выпуски? Если да, то наверняка помните, когда вышел фильм «Ирония судьбы» и случился Карибский кризис. А если нет, сейчас узнаете, да и лишний раз посмотреть «Намедни» всегда приятно. В общем, беспроигрышный тест!</p>"


finishPage_ =
    "<div id=\"share\"><div class=\"top-block\"><img src=\"https://miro.medium.com/max/660/1*bwSiWbEBA7IyZNyqu2bgBQ.png\" class=\"logo\"><span class=\"commercial\"></span></div><div class=\"inner-container\"><div class=\"middle-block\"><div class=\"title\">Когда в СССР появилась «Пепси»? Проверим, смотрели ли вы программу «Намедни»</div><div class=\"share-container\"><div id=\"score\">5/11</div><div id=\"description\"></div></div></div></div></div>"
