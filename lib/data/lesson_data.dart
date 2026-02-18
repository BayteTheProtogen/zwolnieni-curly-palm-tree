import '../models/lesson_models.dart';

final List<Module> appModules = [
  Module(
    id: 'm1',
    title: 'Bezpieczne Hasła',
    description: 'Naucz się tworzyć hasła, których nikt nie zgadnie.',
    lessons: [
      Lesson(
        id: 'm1_l1',
        title: 'Podstawy silnego hasła',
        tasks: [
          Task(
            id: 'm1_l1_t1',
            type: TaskType.multipleChoice,
            question: 'Które z tych haseł jest najbezpieczniejsze?',
            options: ['123456', 'Admin1', 'Kawa!2024#Zima', 'mojeimie'],
            correctOptionIndex: 2,
            explanation: 'Dobre hasło powinno być długie i zawierać duże litery, cyfry oraz znaki specjalne.',
          ),
          Task(
            id: 'm1_l1_t2',
            type: TaskType.multipleChoice,
            question: 'Czy używanie tego samego hasła do wszystkich kont jest bezpieczne?',
            options: ['Tak, łatwiej zapamiętać', 'Nie, to bardzo niebezpieczne'],
            correctOptionIndex: 1,
            explanation: 'Jeśli ktoś pozna jedno hasło, uzyska dostęp do wszystkich Twoich kont.',
          ),
        ],
      ),
      Lesson(
        id: 'm1_l2',
        title: 'Menedżery haseł',
        tasks: [
          Task(
            id: 'm1_l2_t1',
            type: TaskType.multipleChoice,
            question: 'Gdzie najlepiej przechowywać hasła?',
            options: ['Na kartce przy monitorze', 'W głowie', 'W bezpiecznym menedżerze haseł', 'W pliku "hasla.txt"'],
            correctOptionIndex: 2,
            explanation: 'Menedżer haseł to bezpieczny cyfrowy sejf na Twoje dane.',
          ),
        ],
      ),
    ],
  ),
  Module(
    id: 'm2',
    title: 'Phishing i Oszustwa',
    description: 'Jak rozpoznać fałszywe wiadomości.',
    lessons: [
      Lesson(
        id: 'm2_l1',
        title: 'Fałszywe SMS-y',
        tasks: [
          Task(
            id: 'm2_l1_t1',
            type: TaskType.chatSimulation,
            question: 'Dostajesz SMS od "InPostu":',
            chatMessages: [
              ChatMessage(text: 'Twoja paczka została wstrzymana z powodu niedopłaty 1.50 zł. Kliknij: bit.ly/falszywy-link', isUser: false),
            ],
            options: ['Klikam i dopłacam', 'Ignoruję i usuwam'],
            correctOptionIndex: 1,
            explanation: 'Firmy kurierskie nigdy nie proszą o małe dopłaty przez podejrzane linki w SMS-ach.',
          ),
          Task(
            id: 'm2_l1_t2',
            type: TaskType.findTheCatch,
            question: 'Spójrz na tę wiadomość. Co wzbudza Twój niepokój?',
            imageUrl: 'assets/images/fake_sms_1.png',
            catchRegions: [
              CatchRegion(x: 0.2, y: 0.8, width: 0.6, height: 0.1, description: 'Podejrzany link z nietypową końcówką.'),
            ],
            correctOptionIndex: 0,
            explanation: 'Zawsze sprawdzaj linki! Prawdziwy link InPostu to inpost.pl, a nie dziwne skróty.',
          ),
        ],
      ),
      Lesson(
        id: 'm2_l2',
        title: 'Oszustwo "Na wnuczka"',
        tasks: [
          Task(
            id: 'm2_l2_t1',
            type: TaskType.chatSimulation,
            question: 'Dzwoni nieznany numer. Głos w słuchawce mówi:',
            chatMessages: [
              ChatMessage(text: 'Cześć babciu, to ja! Miałem wypadek i pilnie potrzebuję pieniędzy na kaucję. Proszę, nie mów nikomu!', isUser: false),
            ],
            options: [
              'Ojej, już biegnę do banku!',
              'Rozłączam się i dzwonię do wnuczka na jego znany mi numer',
            ],
            correctOptionIndex: 1,
            explanation: 'Oszuści często udają rodzinę w kłopotach. Zawsze weryfikuj takie informacje dzwoniąc bezpośrednio do bliskich.',
          ),
        ],
      ),
    ],
  ),
  Module(
    id: 'm3',
    title: 'Bezpieczne Zakupy',
    description: 'Kupuj w sieci bez strachu.',
    lessons: [
      Lesson(
        id: 'm3_l1',
        title: 'Rozpoznawanie sklepu',
        tasks: [
          Task(
            id: 'm3_l1_t1',
            type: TaskType.multipleChoice,
            question: 'Widzisz super ofertę: iPhone za 200 zł na stronie "Alledrogo.pl.net". Co robisz?',
            options: ['Kupuję natychmiast!', 'Sprawdzam opinie i adres strony', 'To na pewno okazja'],
            correctOptionIndex: 1,
            explanation: 'Zbyt niskie ceny i dziwne adresy stron (jak .pl.net) to typowe znaki oszustwa.',
          ),
        ],
      ),
    ],
  ),
  Module(
    id: 'm4',
    title: 'Bankowość Mobilna',
    description: 'Twoje pieniądze są bezpieczne, jeśli wiesz jak o nie dbać.',
    lessons: [
      Lesson(
        id: 'm4_l1',
        title: 'Logowanie do banku',
        tasks: [
          Task(
            id: 'm4_l1_t1',
            type: TaskType.multipleChoice,
            question: 'Czy bank może poprosić Cię przez telefon o podanie hasła do logowania?',
            options: ['Tak, jeśli to pracownik', 'Nigdy'],
            correctOptionIndex: 1,
            explanation: 'Pracownik banku nigdy nie zapyta o Twoje pełne hasło ani kod BLIK.',
          ),
          Task(
            id: 'm4_l1_t2',
            type: TaskType.multipleChoice,
            question: 'Dostajesz powiadomienie o autoryzacji przelewu, którego nie zlecałeś. Co robisz?',
            options: ['Akceptuję, pewnie to błąd systemu', 'Odrzucam i dzwonię na infolinię banku'],
            correctOptionIndex: 1,
            explanation: 'Nigdy nie zatwierdzaj operacji, których nie zlecałeś osobiście!',
          ),
        ],
      ),
      Lesson(
        id: 'm4_l2',
        title: 'Bezpieczny Bankomat',
        tasks: [
          Task(
            id: 'm4_l2_t1',
            type: TaskType.multipleChoice,
            question: 'Co robisz wpisując PIN w bankomacie?',
            options: ['Wpisuję szybko', 'Zakrywam klawiaturę drugą ręką', 'Proszę kogoś o pomoc'],
            correctOptionIndex: 1,
            explanation: 'Zakrywanie klawiatury chroni Twój PIN przed ukrytymi kamerami oszustów.',
          ),
        ],
      ),
    ],
  ),
];
