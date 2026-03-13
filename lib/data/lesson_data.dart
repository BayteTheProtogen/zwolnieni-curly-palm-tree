import '../models/lesson_models.dart';

final List<CybersecurityModule> cybersecurityModules = [
  CybersecurityModule(
    id: 'm1',
    title: 'Mocne Hasła',
    description: 'Naucz się tworzyć hasła nie do złamania.',
    badge: CyberBadge(
      id: 'badge_m1',
      name: 'Mistrz Haseł',
      description: 'Ukończono moduł o bezpiecznych hasłach.',
      icon: '🔐',
    ),
    lessons: [
      Lesson(
        id: 'm1_l1',
        title: 'Dlaczego hasło jest ważne?',
        tasks: [
          Task(
            id: 'm1_l1_t1',
            type: TaskType.theory,
            question: 'Klucz do Twojego cyfrowego domu',
            explanation: 'Hasło to pierwsza i najważniejsza linia obrony. Słabe hasło jest jak zostawienie klucza w drzwiach.',
          ),
          Task(
            id: 'm1_l1_t2',
            type: TaskType.multipleChoice,
            question: 'Które hasło jest najbezpieczniejsze?',
            options: ['123456', 'admin1', 'Moje!Haslo.2024', 'qwerty'],
            correctOptionIndex: 2,
            explanation: 'Dobre hasło powinno mieć duże i małe litery, cyfry oraz znaki specjalne.',
          ),
        ],
      ),
      Lesson(
        id: 'm1_l2',
        title: 'Menedżery haseł',
        tasks: [
          Task(
            id: 'm1_l2_t1',
            type: TaskType.theory,
            question: 'Cyfrowy sejf',
            explanation: 'Nie musisz pamiętać setek haseł. Menedżer haseł zapamięta je za Ciebie i bezpiecznie zaszyfruje.',
          ),
          Task(
            id: 'm1_l2_t2',
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
  CybersecurityModule(
    id: 'm2',
    title: 'Phishing i Oszustwa',
    description: 'Jak rozpoznać fałszywe wiadomości.',
    badge: CyberBadge(
      id: 'badge_m2',
      name: 'Pogromca Phishingu',
      description: 'Potrafisz rozpoznać fałszywe wiadomości.',
      icon: '🎣',
    ),
    lessons: [
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
        ],
      ),
    ],
  ),
  CybersecurityModule(
    id: 'm3',
    title: 'Bezpieczne Zakupy',
    description: 'Kupuj w sieci bez strachu.',
    badge: CyberBadge(
      id: 'badge_m3',
      name: 'Świadomy Konsument',
      description: 'Wiesz jak bezpiecznie kupować w internecie.',
      icon: '🛒',
    ),
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
            explanation: 'Zbyt niskie ceny i dziwne adresy stron to typowe znaki oszustwa.',
          ),
        ],
      ),
    ],
  ),
  CybersecurityModule(
    id: 'm4',
    title: 'Bankowość Mobilna',
    description: 'Twoje pieniądze są bezpieczne.',
    badge: CyberBadge(
      id: 'badge_m4',
      name: 'Strażnik Bankowości',
      description: 'Znasz zasady bezpiecznego korzystania z banku.',
      icon: '🏦',
    ),
    lessons: [
      Lesson(
        id: 'm4_l1',
        title: 'Logowanie do banku',
        tasks: [
          Task(
            id: 'm4_l1_t1',
            type: TaskType.multipleChoice,
            question: 'Czy bank może poprosić Cię o podanie hasła przez telefon?',
            options: ['Tak, jeśli to pracownik', 'Nigdy'],
            correctOptionIndex: 1,
            explanation: 'Pracownik banku nigdy nie zapyta o Twoje pełne hasło.',
          ),
        ],
      ),
    ],
  ),
];
