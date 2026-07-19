= Fazit und Ausblick

== Fazit

Die vorliegende Arbeit untersucht eine Forschungsfrage, die aus zwei Teilproblemen öffentlicher Kiosk-Systeme entsteht: einerseits dem bewussten Verzicht auf Login-Mechanismen @porcheron2018voice[S.~3], andererseits dem fehlenden persistenten Gedächtnis großer Sprachmodelle über Sitzungsgrenzen hinweg @zhang2018persona[S.~2388]:

#rect(width: 100%, inset: (x: 12pt, y: 10pt), radius: 4pt, stroke: 0.5pt)[
  _„Wie kann ein öffentlicher KI-Assistent durch kamerabasierte Gesichtserkennung mittels Deep-Learning-Embeddings wiederkehrende Nutzer identifizieren und eine sitzungsübergreifend personalisierte Konversationserfahrung bereitstellen?"_
]

Die Frage lässt sich auf Basis des entwickelten und evaluierten Prototyps positiv beantworten: Ein öffentlicher KI-Assistent kann wiederkehrende Nutzer durch kamerabasierte Gesichtserkennung zuverlässig identifizieren --- und über strukturierte Fakt-Extraktion mit RAG-Retrieval eine personalisierte Konversation aufbauen, die über einzelne Sitzungen hinaus trägt.

Die Evaluation in Kap.~7 stützt diese Antwort in ihren drei Dimensionen unterschiedlich stark, und diese Abstufung ist der eigentliche Erkenntnisgewinn. Die Erkennungsgenauigkeit ist die belastbarste Aussage: Das gewählte Verfahren bewegt sich auf dem Niveau etablierter Benchmarks, und für den Kiosk-Kontext --- in dem ein Fehler eine falsche Begrüßung, kein Sicherheitsrisiko bedeutet --- ist die verbleibende Fehlerrate unkritisch. Die Latenz zeigt, dass die eigentliche Personalisierungsleistung nicht der Engpass ist: Nicht die biometrische Identifikation, sondern die bewusst gesetzten Wartezeiten der Interaktionslogik dominieren die Antwortzeit, die damit im für einen Kiosk akzeptablen Rahmen bleibt. Die Robustheit schließlich markiert die Grenze des Verfahrens --- die Winkelabhängigkeit der Gesichtserkennung --- und macht zugleich sichtbar, warum das zweistufige Tracking diese Grenze im laufenden Betrieb abfängt.

Der eigentliche Beitrag der Arbeit liegt damit weniger in den einzelnen Verfahren --- diese sind etabliert --- als in ihrer Integration zu einem kohärenten Stack: Frontaldetektion, zweistufiges Tracking, Embedding-basierte Identifikation und ein nicht-parametrisches Gesprächsgedächtnis greifen so ineinander, dass die in Kap.~1.1 beschriebene strukturelle Personalisierungslücke öffentlicher Kiosk-Systeme geschlossen wird --- ohne Login, ohne GPU-Server und ohne proprietären Vendor Lock-in. Die architektonische Entkopplung über Microservices und das FaceStore-Interface hält diese Lösung zugleich für andere Einsatzkontexte offen.

Drei Designentscheidungen heben sich dabei als originelle Beiträge hervor. Erstens der Einsatz des Vision-LLM (Gemini 2.5 Flash) als kalibrierungsfreie Interaktionsvalidierung: Klassische Gaze-Estimation erfordert eine benutzerspezifische Kalibrierungssitzung und ist für öffentliche Kioske mit wechselnden Passanten strukturell nicht einsetzbar; das Vision-LLM (vgl. Kap.~3.2) ersetzt diesen Schritt durch zero-shot Frontalitätserkennung ohne Vorwissen über den jeweiligen Nutzer. Zweitens das spekulative Pre-Computing der Begrüßung als Latenz-Engineering-Muster: Die personalisierte Begrüßung wird parallel zum laufenden Gaze-Check erzeugt --- nicht erst nach dessen Abschluss --- sodass die LLM-Generierungslatenz aus dem wahrnehmbaren Begrüßungsweg entfällt (vgl. Kap.~4.3). Drittens das dreikanalige Gedächtnisdesign aus `summary`, `facts_sentences` und `facts`: Drei strukturell getrennte Persistenzkanäle bedienen semantisch verschiedene Bedürfnisse --- kompakter Sitzungskontext, retrieval-fähige Einzelfakten und stabile Kerndaten ohne Suchlatenz --- als aktive Designentscheidung, die das System gesprächsfähig über Sitzungsgrenzen hinweg hält (vgl. Kap.~6.1).

Diese Antwort steht unter dem Vorbehalt ihrer Evaluationsbasis: Die Ergebnisse stützen sich auf Literatur-Benchmarks und Beobachtungen aus dem Entwicklungsbetrieb, nicht auf eine kontrollierte Probandenstudie. Der Prototyp belegt damit die technische Machbarkeit; der empirische Nachweis unter realen Kiosk-Bedingungen bleibt der in Kap.~7.3 als offen markierten Weiterarbeit vorbehalten.

== Ausblick

Obwohl der Prototyp die Forschungsfrage beantwortet, eröffnet er mehrere Weiterentwicklungsrichtungen.

Die unmittelbar interessanteste ist die Domänenübertragung: Das System ist prinzipiell nicht auf den SAP-Kiosk-Kontext beschränkt, sondern auf alle Settings übertragbar, in denen Nutzer bekannt sind, aber keine explizite Login-Infrastruktur existiert @porcheron2018voice[S.~4]. Denkbare Anwendungsfelder reichen von der Pflege (Begrüßung beim Betreten eines Patientenzimmers ohne Geräteentsperrung) über den Bildungsbereich (adaptive Lernsysteme, die Lernhistorie ohne Login laden) bis hin zum Retail (Beratungssysteme, die Stammkunden erkennen und auf frühere Präferenzen eingehen).

Die zweite Richtung betrifft die datenschutzrechtliche Konsolidierung. Der Prototyp wurde unter internen Laborbedingungen entwickelt; die in Kap.~3.5 identifizierten Produktivierungsvoraussetzungen lassen sich in drei konkrete Schritte gliedern:
(1) _Opt-in-Mechanismus_ gemäß Art.~9 Abs.~2 lit.~a DSGVO --- einen expliziten Einwilligungs-Dialog implementieren, in dem Nutzer ihre Zustimmung zur Verarbeitung biometrischer Daten vor der ersten Registrierung aktiv erteilen;
(2) _Datenschutz-Folgenabschätzung_ (DSFA) gemäß Art.~35 DSGVO @dsgvo2016[Art.~35] --- eine dokumentierte Risikoanalyse der biometrischen Verarbeitungsprozesse durchführen und der zuständigen Datenschutzbehörde vor einem produktiven Rollout vorlegen;
(3) _Löschfunktion_ gemäß Art.~17 DSGVO @dsgvo2016[Art.~17] --- eine API-Funktion oder Admin-Oberfläche erstellen, über die gespeicherte Embeddings und Gesprächsprofile auf Anfrage vollständig gelöscht werden können @krivokucahahn2023biometricprotection[S.~639--641].
Diese drei Schritte erfordern keine Architekturumbauten, sondern ergänzende Implementierung auf Basis des bestehenden FaceStore-Interfaces (vgl. Kap.~3.4).

Die dritte Richtung ist die technische Reifung: Eine kontrollierte Studie mit standardisierten Bedingungen und einer größeren Probandengruppe würde die auf Benchmark-Werten basierenden Genauigkeitsaussagen empirisch absichern und die Langzeitstabilität des EMA-Embedding-Gedächtnisses über Wochen und Monate validieren.
