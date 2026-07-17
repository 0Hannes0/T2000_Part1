= Fazit und Ausblick

== Fazit

Die vorliegende Arbeit untersucht eine Forschungsfrage, die aus zwei Teilproblemen öffentlicher Kiosk-Systeme entsteht: einerseits dem bewussten Verzicht auf Login-Mechanismen @porcheron2018voice[S.~3], andererseits dem fehlenden persistenten Gedächtnis großer Sprachmodelle über Sitzungsgrenzen hinweg @zhang2018persona[S.~2388]:

#rect(width: 100%, inset: (x: 12pt, y: 10pt), radius: 4pt, stroke: 0.5pt)[
  _„Wie kann ein öffentlicher KI-Assistent durch kamerabasierte Gesichtserkennung mittels Deep-Learning-Embeddings wiederkehrende Nutzer identifizieren und eine sitzungsübergreifend personalisierte Konversationserfahrung bereitstellen?"_
]

Die Frage lässt sich auf Basis des entwickelten und evaluierten Prototyps positiv beantworten: Ein öffentlicher KI-Assistent kann wiederkehrende Nutzer durch kamerabasierte Gesichtserkennung zuverlässig identifizieren --- und über strukturierte Fakt-Extraktion mit RAG-Retrieval eine personalisierte Konversation aufbauen, die über einzelne Sitzungen hinaus trägt.

Die Evaluation in Kap.~7 stützt diese Antwort in ihren drei Dimensionen unterschiedlich stark, und diese Abstufung ist der eigentliche Erkenntnisgewinn. Die Erkennungsgenauigkeit ist die belastbarste Aussage: Das gewählte Verfahren bewegt sich auf dem Niveau etablierter Benchmarks, und für den Kiosk-Kontext --- in dem ein Fehler eine falsche Begrüßung, kein Sicherheitsrisiko bedeutet --- ist die verbleibende Fehlerrate unkritisch. Die Latenz zeigt, dass die eigentliche Personalisierungsleistung nicht der Engpass ist: Nicht die biometrische Identifikation, sondern die bewusst gesetzten Wartezeiten der Interaktionslogik dominieren die Antwortzeit, die damit im für einen Kiosk akzeptablen Rahmen bleibt. Die Robustheit schließlich markiert die Grenze des Verfahrens --- die Winkelabhängigkeit der Gesichtserkennung --- und macht zugleich sichtbar, warum das zweistufige Tracking diese Grenze im laufenden Betrieb abfängt.

Der eigentliche Beitrag der Arbeit liegt damit weniger in den einzelnen Verfahren --- diese sind etabliert --- als in ihrer Integration zu einem kohärenten Stack: Frontaldetektion, zweistufiges Tracking, Embedding-basierte Identifikation und ein nicht-parametrisches Gesprächsgedächtnis greifen so ineinander, dass die in Kap.~1.1 beschriebene strukturelle Personalisierungslücke öffentlicher Kiosk-Systeme geschlossen wird --- ohne Login, ohne GPU-Server und ohne proprietären Vendor Lock-in. Die architektonische Entkopplung über Microservices und das FaceStore-Interface hält diese Lösung zugleich für andere Einsatzkontexte offen.

Diese Antwort steht unter dem Vorbehalt ihrer Evaluationsbasis: Die Ergebnisse stützen sich auf Literatur-Benchmarks und Beobachtungen aus dem Entwicklungsbetrieb, nicht auf eine kontrollierte Probandenstudie. Der Prototyp belegt damit die technische Machbarkeit; der empirische Nachweis unter realen Kiosk-Bedingungen bleibt der in Kap.~7.3 als offen markierten Weiterarbeit vorbehalten.

== Ausblick

Obwohl der Prototyp die Forschungsfrage beantwortet, eröffnet er mehrere Weiterentwicklungsrichtungen.

Die unmittelbar interessanteste ist die Domänenübertragung: Das System ist prinzipiell nicht auf den SAP-Kiosk-Kontext beschränkt, sondern auf alle Settings übertragbar, in denen Nutzer bekannt sind, aber keine explizite Login-Infrastruktur existiert @porcheron2018voice[S.~4]. Denkbare Anwendungsfelder reichen von der Pflege (Begrüßung beim Betreten eines Patientenzimmers ohne Geräteentsperrung) über den Bildungsbereich (adaptive Lernsysteme, die Lernhistorie ohne Login laden) bis hin zum Retail (Beratungssysteme, die Stammkunden erkennen und auf frühere Präferenzen eingehen).

Die zweite Richtung betrifft die datenschutzrechtliche Konsolidierung. Der Prototyp wurde unter internen Laborbedingungen entwickelt; die in Kap.~3.5 identifizierten Produktivierungsvoraussetzungen --- Einwilligungsmechanismen, Löschrecht und Datenschutz-Folgenabschätzung --- müssten für einen öffentlichen Einsatz vollständig umgesetzt werden @hogenhout2025biometricprivacy[S.~2--4].

Die dritte Richtung ist die technische Reifung: Eine kontrollierte Studie mit standardisierten Bedingungen und einer größeren Probandengruppe würde die auf Benchmark-Werten basierenden Genauigkeitsaussagen empirisch absichern und die Langzeitstabilität des EMA-Embedding-Gedächtnisses über Wochen und Monate validieren @barquero2020longtermtracking[S.~4--5].
