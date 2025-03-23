import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:kite/logic/article.dart';
import 'package:shouldly/shouldly.dart';

void main() {
  group('test article logic', () {
    const avgSpeed = 200; // reading speed in words per minute
    const tolerance = 0.05; // percentage

    testCases([
      const TestCase([325, (325 / avgSpeed)]),
    ], (testCase) {
      final length = testCase.args[0] as int;
      final estimate = (testCase.args[1] as double).ceil();

      given('an article of approximately $length words', () {
        final article = _kArticle;

        when('the time to read is calculated', () {
          final time = article.readTime();

          then('it is roughly $estimate minutes', () {
            time.should.beTolerantOf(estimate, tolerance: tolerance);
          });
        });
      });
    });
  });
}

final _kArticle = Article(
  group: "Diplomacy",
  title: "Trump to discuss Ukraine war with Putin on Tuesday",
  summary:
      "US President Donald Trump announced he will speak with Russian President Vladimir Putin on Tuesday, March 18, to discuss ending the war in Ukraine. Trump indicated that the conversation will include discussions about \"dividing up certain assets,\" including land and power plants, following what he described as productive weekend negotiations. The Kremlin has confirmed the planned call as Ukraine has reportedly accepted a US-backed 30-day ceasefire proposal.",
  highlights: [
    (
      title: "Ceasefire proposal",
      content:
          "Ukraine has reportedly accepted a US-backed 30-day ceasefire proposal that Trump is trying to get Putin to support.",
    ),
  ],
  quote: (
    author: "Donald Trump",
    content:
        "We will be talking about land. We will be talking about power plants...We're already talking about that, dividing up certain assets.",
    domain: "theguardian.com",
    url:
        "https://www.theguardian.com/world/2025/mar/17/trump-says-he-and-putin-will-discuss-land-and-powerplants-in-ukraine-ceasefire-talks",
  ),
  perspectives: [
    (
      title: "US administration",
      text:
          "Trump believes a deal to end the war is possible, citing \"a lot of work\" done over the weekend and expressing confidence in the negotiations.",
      sources: [
        (
          name: "The Guardian",
          url:
              "https://www.theguardian.com/world/2025/mar/17/trump-says-he-and-putin-will-discuss-land-and-powerplants-in-ukraine-ceasefire-talks",
          date: null,
          domain: null,
        ),
      ],
    ),
    (
      title: "Russian position",
      text:
          "Russia demands that any peace agreement must include Ukraine's exclusion from NATO and neutral status, with Deputy Foreign Minister Alexander Grushko calling for \"ironclad security guarantees.\"",
      sources: [
        (
          name: "TASS",
          url: "https://tass.com/politics/1928999",
          date: null,
          domain: null,
        ),
      ],
    ),
  ],
  background:
      "Russia launched a full-scale invasion of Ukraine in February 2022, initially aiming to topple the Ukrainian government but failing to achieve this objective. Despite this setback, Russian forces continue to occupy large swaths of Ukrainian territory across the east and south, with fighting continuing along multiple fronts for over three years.",
  reactions: [
    (
      title: "🇬🇧 United Kingdom",
      content:
          "Offered to send peacekeepers to monitor any ceasefire in Ukraine.",
    ),
    (
      title: "🇫🇷 France",
      content:
          "Expressed willingness to deploy a peacekeeping force to monitor a potential ceasefire.",
    ),
  ],
  timeline: [
    (
      date: "February 2022",
      title: "Russia launches full-scale invasion of Ukraine",
    ),
    (
      date: "March 2023",
      title:
          "International Criminal Court issues arrest warrants for Putin over unlawful deportation of children",
    ),
  ],
  sources: [
    (
      name: "Trump and Putin Will Talk Tuesday in Push to End Ukraine War",
      url: "https://time.com/7268806/trump-putin-russia-ukraine-war-zelensky/",
      domain: "time.com",
      date: DateTime.parse("2025-03-17T05:58:55+00:00"),
    ),
  ],
  fact:
      "The call between Trump and Putin will be their first known conversation since Putin laid out numerous conditions for a potential ceasefire with Ukraine.",
);
