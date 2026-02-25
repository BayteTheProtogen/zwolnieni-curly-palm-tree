import '../models/lesson_models.dart';

final List<Module> appModules = [
  Module(
    id: 'm0',
    title: 'Wstęp do Bezpieczeństwa',
    description: 'Dlaczego warto dbać o swoje dane w internecie?',
    lessons: [
      Lesson(
        id: 'm0_l1',
        title: 'Cyfrowy Świat',
        tasks: [
          Task(
            id: 'm0_l1_t1',
            type: TaskType.theory,
            question: 'Witaj w świecie bezpieczeństwa!',
            explanation: 'Internet to wspaniałe miejsce, ale jak w prawdziwym świecie, musimy znać zasady bezpieczeństwa. Twoje dane, takie jak PESEL czy hasło do banku, są jak klucze do Twojego domu.',
          ),
          Task(
            id: 'm0_l1_t2',
            type: TaskType.theory,
            question: 'Kto chce Twoich danych?',
            explanation: 'Oszuści (cyberprzestępcy) chcą Twoich informacji, aby ukraść pieniądze lub podszyć się pod Ciebie. Będziemy Cię uczyć, jak ich przechytrzyć!',
          ),
          Task(
            id: 'm0_l1_t3',
            type: TaskType.multipleChoice,
            question: 'Do czego można porównać hasło w internecie?',
            options: ['Do nazwiska', 'Do klucza do mieszkania', 'Do numeru telefonu'],
            correctOptionIndex: 1,
            explanation: 'Hasło chroni dostęp do Twoich prywatnych rzeczy, tak jak klucz chroni Twój dom.',
          ),
        ],
      ),
    ],
  ),
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
            id: 'm1_l1_t0',
            type: TaskType.theory,
            question: 'Co to jest silne hasło?',
            explanation: 'Silne hasło to takie, które trudno odgadnąć komputerowi i człowiekowi. Powinno mieć co najmniej 12 znaków i być mieszanką liter, cyfr i symboli.',
          ),
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
            id: 'm1_l2_t0',
            type: TaskType.theory,
            question: 'Jak zapamiętać tyle haseł?',
            explanation: 'Nie musisz! Menedżer haseł to aplikacja, która pamięta wszystkie hasła za Ciebie. Ty musisz pamiętać tylko jedno "główne" hasło do tego sejfu.',
          ),
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
      Lesson(
        id: 'm1_l3',
        title: 'Weryfikacja dwuetapowa (2FA)',
        tasks: [
          Task(
            id: 'm1_l3_t1',
            type: TaskType.theory,
            question: 'Druga linia obrony',
            explanation: 'Nawet jeśli oszust pozna Twoje hasło, weryfikacja dwuetapowa go powstrzyma. To dodatkowy kod, który dostajesz np. SMS-em podczas logowania.',
          ),
          Task(
            id: 'm1_l3_t2',
            type: TaskType.multipleChoice,
            question: 'Co daje weryfikacja dwuetapowa?',
            options: ['Spowalnia logowanie', 'Dodatkową warstwę ochrony', 'Nic nie daje'],
            correctOptionIndex: 1,
            explanation: 'To jak drugi zamek w drzwiach – jeden klucz to za mało, by wejść.',
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
        id: 'm2_l0',
        title: 'Czym jest Phishing?',
        tasks: [
          Task(
            id: 'm2_l0_t1',
            type: TaskType.theory,
            question: 'Wędkarstwo oszustów',
            explanation: 'Phishing (czyt. fiszing) to metoda, w której oszust "zarzuca haczyk" – wysyła wiadomość podszywając się pod znaną firmę, by skłonić Cię do podania danych.',
          ),
        ],
      ),
      Lesson(
        id: 'm2_l1',
        title: 'Fałszywe SMS-y',
        tasks: [
          Task(
            id: 'm2_l1_t1',
            type: TaskType.chatSimulation,
            question: 'Dostajesz SMS od "ImPostu":',
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
            id: 'm3_l1_t0',
            type: TaskType.theory,
            question: 'Zanim klikniesz "Kupuję"',
            explanation: 'Prawdziwy sklep powinien mieć regulamin, dane kontaktowe i adres w Polsce. Uważaj na sklepy, które istnieją od wczoraj i mają niesamowite promocje.',
          ),
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
      Lesson(
        id: 'm3_l2',
        title: 'Bezpieczne Płatności',
        tasks: [
          Task(
            id: 'm3_l2_t1',
            type: TaskType.theory,
            question: 'Jak płacić bezpiecznie?',
            explanation: 'Najlepiej korzystać ze znanych metod: BLIK, szybkie przelewy przez bramki (np. PayU, Przelewy24) lub płatność przy odbiorze.',
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
            id: 'm4_l1_t0',
            type: TaskType.theory,
            question: 'Twoja twierdza',
            explanation: 'Nigdy nie loguj się do banku przez linki z e-maili lub SMS-ów. Zawsze wpisuj adres banku ręcznie lub używaj oficjalnej aplikacji.',
          ),
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
  Module(
    id: 'm5',
    title: 'Media Społecznościowe',
    description: 'Bezpieczeństwo na Facebooku i nie tylko.',
    lessons: [
      Lesson(
        id: 'm5_l1',
        title: 'Prywatność zdjęć',
        tasks: [
          Task(
            id: 'm5_l1_t1',
            type: TaskType.theory,
            question: 'Kto to widzi?',
            explanation: 'Zdjęcia Twoich wnuków lub Twojego domu nie muszą być widoczne dla całego świata. Ustaw widoczność postów "Tylko dla znajomych".',
          ),
          Task(
            id: 'm5_l1_t2',
            type: TaskType.spotTheDifference,
            question: 'Który profil jest poprawnie zabezpieczony?',
            imageUrl: 'secure_profile.png',
            secondaryImageUrl: 'public_profile.png',
            correctOptionIndex: 0,
            explanation: 'Profil prywatny (A) pozwala widzieć posty tylko osobom, które zaakceptujesz.',
          ),
        ],
      ),
    ],
  ),
  Module(
    id: 'm6',
    title: 'Bezpieczny Smartfon',
    description: 'Twój telefon to Twój portfel i pamiętnik.',
    lessons: [
      Lesson(
        id: 'm6_l1',
        title: 'Blokada ekranu',
        tasks: [
          Task(
            id: 'm6_l1_t1',
            type: TaskType.theory,
            question: 'Dlaczego blokować?',
            explanation: 'Zawsze miej ustawioną blokadę ekranu (PIN, wzór lub odcisk palca). Jeśli zgubisz telefon, nikt nie dobierze się do Twoich banków i zdjęć.',
          ),
          Task(
            id: 'm6_l1_t2',
            type: TaskType.ordering,
            question: 'Co robisz, gdy zgubisz telefon?',
            options: ['Dzwonię do banku zablokować kartę', 'Używam "Znajdź moje urządzenie"', 'Zgłaszam na policję'],
            correctOrder: [1, 0, 2],
            explanation: 'Najpierw spróbuj namierzyć telefon i zdalnie go zablokować, potem zabezpiecz swoje pieniądze.',
          ),
        ],
      ),
    ],
  ),
  Module(
    id: 'm7',
    title: 'Sieci WiFi i Internet',
    description: 'Jak łączyć się bezpiecznie w kawiarni i u lekarza.',
    lessons: [
      Lesson(
        id: 'm7_l1',
        title: 'Publiczne WiFi',
        tasks: [
          Task(
            id: 'm7_l1_t1',
            type: TaskType.theory,
            question: 'Darmowy Internet?',
            explanation: 'Publiczne, otwarte sieci WiFi w galeriach czy parkach mogą być "podsłuchiwane" przez oszustów. Nigdy nie loguj się do banku w takiej sieci!',
          ),
          Task(
            id: 'm7_l1_t2',
            type: TaskType.multipleChoice,
            question: 'Musisz zapłacić rachunek w kawiarni na ich darmowym WiFi. Co robisz?',
            options: ['Płacę szybko', 'Wyłączam WiFi i używam danych komórkowych', 'Pytam kelnera o hasło i wtedy płacę'],
            correctOptionIndex: 1,
            explanation: 'Twoje dane komórkowe są znacznie bezpieczniejsze niż darmowe WiFi w miejscu publicznym.',
          ),
        ],
      ),
    ],
  ),
];
