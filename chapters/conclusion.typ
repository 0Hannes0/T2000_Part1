= Fazit und Ausblick

== Fazit

Die vorliegende Arbeit untersucht eine Forschungsfrage, die aus zwei Teilproblemen öffentlicher Kiosk-Systeme entsteht: einerseits dem bewussten Verzicht auf Login-Mechanismen @porcheron2018voice[S.~3], andererseits dem fehlenden persistenten Gedächtnis großer Sprachmodelle über Sitzungsgrenzen hinweg @zhang2018persona[S.~2388]:

#rect(width: 100%, inset: (x: 12pt, y: 10pt), radius: 4pt, stroke: 0.5pt)[
  _„Wie kann ein öffentlicher KI-Assistent durch kamerabasierte Gesichtserkennung mittels Deep-Learning-Embeddings wiederkehrende Nutzer identifizieren und eine sitzungsübergreifend personalisierte Konversationserfahrung bereitstellen?"_
]

Die Frage lässt sich positiv beantworten: Der Prototyp erkennt wiederkehrende Nutzer per kamerabasierter Gesichtserkennung zuverlässig wieder und stellt über strukturierte Fakt-Extraktion mit RAG-Retrieval eine personalisierte Konversation her, die über einzelne Sitzungen hinaus trägt. Wiedererkennung, Kontextabruf und sitzungsübergreifende Personalisierung sind umgesetzt und im dreimonatigen Testbetrieb bestätigt (vgl. Kap.~7).

Die Evaluation stützt diese Antwort in allen drei Dimensionen. Die Erkennungsgenauigkeit liegt auf dem Niveau etablierter Benchmarks, und für den Kiosk-Kontext --- ein Fehler bedeutet eine falsche Begrüßung, kein Sicherheitsrisiko --- ist die verbleibende Fehlerrate unkritisch. Die Latenz wird nicht von der biometrischen Identifikation bestimmt, sondern von den bewusst gesetzten Wartezeiten der Interaktionslogik, und bleibt damit im angenehmen Rahmen. Und die Robustheit gegenüber Kopfdrehungen und wechselndem Licht wird durch das zweistufige Tracking und die Schwellenwert-Kalibrierung im laufenden Betrieb sicher aufgefangen.

Der Beitrag der Arbeit liegt weniger in den einzelnen Verfahren --- diese sind etabliert --- als in ihrer Integration zu einem funktionierenden Gesamtsystem: Frontaldetektion, zweistufiges Tracking, Embedding-basierte Identifikation und ein Gesprächsgedächtnis greifen so ineinander, dass die in Kap.~1.1 beschriebene Personalisierungslücke öffentlicher Kiosk-Systeme geschlossen wird --- ohne Login und ohne GPU-Server. Die Entkopplung über Microservices und das FaceStore-Interface hält die Lösung zugleich für andere Einsatzkontexte offen.

Drei Entscheidungen waren dabei besonders hilfreich: der Einsatz des Vision-LLM (Gemini 2.5 Flash) zur Interaktionsprüfung ohne nutzerspezifische Kalibrierung (vgl. Kap.~3.2); die parallele Vorberechnung der Begrüßung zeitgleich zum Gaze-Check, sodass die Generierungslatenz aus dem wahrnehmbaren Ablauf herausfällt (vgl. Kap.~4.3); und das dreikanalige Gedächtnis aus `summary`, `facts_sentences` und `facts`, das kompakten Sitzungskontext, abrufbare Einzelfakten und stabile Kerndaten trennt und das System über Sitzungsgrenzen hinweg gesprächsfähig hält (vgl. Kap.~6.1).

Diese Antwort stützt sich auf die dreimonatige Erprobung im realen Betrieb und auf publizierte Benchmark-Werte der eingesetzten Verfahren. Für einen Prototyp, der seine Tauglichkeit im tatsächlichen Einsatzkontext nachweisen soll, ist das die angemessene Validierungsform. Die Arbeit hat dabei bewusst einen engen Scope gewählt: Die Evaluation konzentriert sich auf Erkennungsgenauigkeit, Latenz und Robustheit --- Dimensionen, die im Testbetrieb direkt beobachtbar waren. Eine quantitative Messung der Personalisierungsqualität sowie eine Evaluation über einen demographisch breiteren Personenkreis bleiben dem Produktivierungspfad vorbehalten.

== Ausblick

Der Prototyp eröffnet mehrere Weiterentwicklungsrichtungen.

Die erste ist die Domänenübertragung: Das System ist nicht auf den SAP-Kiosk beschränkt, sondern auf alle Situationen übertragbar, in denen Nutzer bekannt sind, aber keine Login-Infrastruktur existiert @porcheron2018voice[S.~4]. Denkbare Felder sind die Pflege (Begrüßung beim Betreten eines Patientenzimmers ohne Geräteentsperrung), der Bildungsbereich (adaptive Lernsysteme, die die Lernhistorie ohne Login laden) und der Handel (Beratungssysteme, die Stammkunden wiedererkennen).

Die zweite Richtung ist die datenschutzrechtliche Produktivierung. Der Prototyp entstand unter internen Laborbedingungen; die in Kap.~3.5 genannten Voraussetzungen lassen sich in drei Schritte gliedern:
(1) _Opt-in-Mechanismus_ gemäß Art.~9 Abs.~2 lit.~a DSGVO --- ein Einwilligungs-Dialog, in dem Nutzer der Verarbeitung biometrischer Daten vor der ersten Registrierung aktiv zustimmen;
(2) _Datenschutz-Folgenabschätzung_ (DSFA) gemäß Art.~35 DSGVO @dsgvo2016[Art.~35] --- eine dokumentierte Risikoanalyse der biometrischen Verarbeitung vor einem produktiven Rollout;
(3) _Löschfunktion_ gemäß Art.~17 DSGVO @dsgvo2016[Art.~17] --- eine Funktion, über die gespeicherte Embeddings und Gesprächsprofile auf Anfrage vollständig gelöscht werden @krivokucahahn2023biometricprotection[S.~639--641].
Diese Schritte erfordern keine Architekturumbauten, sondern ergänzende Implementierung auf Basis des bestehenden FaceStore-Interfaces (vgl. Kap.~3.4).

Die dritte Richtung eröffnet noch mehr Potenzial: Rollt man das System für einen größeren und vielfältigeren Personenkreis aus, lässt sich die Erkennung über verschiedene Bevölkerungsgruppen hinweg noch breiter optimieren und die Langzeitstabilität des EMA-Gedächtnisses über viele Monate weiter ausbauen.
