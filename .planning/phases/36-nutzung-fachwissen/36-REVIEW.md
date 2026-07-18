---
phase: 36-nutzung-fachwissen
reviewed: 2026-07-18T00:00:00Z
depth: standard
files_reviewed: 4
files_reviewed_list:
  - T2000_Part1/chapters/fundamentals-1.typ
  - T2000_Part1/chapters/practical-2.typ
  - T2000_Part1/chapters/practical-1.typ
  - T2000_Part1/user/sources.bib
findings:
  critical: 3
  warning: 6
  info: 0
  total: 9
status: issues_found
---

# Phase 36: Code Review Report

**Reviewed:** 2026-07-18
**Depth:** standard
**Files Reviewed:** 4
**Status:** issues_found

## Summary

Reviewed the three chapter files added/modified in Phase 36 (fundamentals-1.typ, practical-1.typ, practical-2.typ) and the shared bibliography (sources.bib). The Wave-2 insertions (WISS-01 through WISS-03) are structurally sound and the new muennighoff2023mteb BibTeX entry is correctly formed. However, three pre-existing citation-to-claim mismatches rise to BLOCKER level: a three-citation cluster in Kap. 2.1.2 that does not support the VLM zero-shot claim, a benchmark-dataset paper cited as a speed-accuracy comparative study, and a conversation-memory paper cited to support an embedding-chunking precision claim it does not address. Six additional WARNING-level issues cover an imprecise EMA phrasing, two citation-key year mismatches, a BibTeX type error, and two citation overstatements in the tracking section.

---

## Critical Issues

### CR-01: VLM zero-shot claim supported by citations that contradict or do not address it

**File:** `T2000_Part1/chapters/fundamentals-1.typ:19`

**Issue:** The sentence "Generative Vision-Language-Modelle (VLMs) wie Gemini 2.5 Flash kombinieren visuelles Verstehen mit Sprachgenerierung und können so Klassifikationsaufgaben direkt aus einer natürlichsprachlichen Beschreibung ausführen --- ohne aufgabenspezifisches Training" is backed by three citations: `@cheng2021gazesurvey[§1, S.~1--2]`, `@yin2024clipgaze[S.~6729--6730]`, and `@yin2024lggaze[S.~1--2]`. None of these support the "ohne aufgabenspezifisches Training" claim for a generative VLM:

- **cheng2021gazesurvey** is an appearance-based gaze estimation survey. Its §1 discusses traditional appearance-based CNN methods and calibration pipelines. It does not discuss generative VLMs or zero-shot classification capability.
- **yin2024clipgaze** (CLIP-Gaze) uses CLIP as a feature extractor *and then trains a task-specific mapping network* on gaze data. The paper explicitly requires training. Citing it for "without task-specific training" inverts the paper's methodology.
- **yin2024lggaze** (LG-Gaze) likewise trains a geometry-aware prompt model on gaze datasets. It is not a zero-shot system.

The claim about Gemini 2.5 Flash being a VLM capable of zero-shot binary judgements is plausible and used in the implementation, but it currently has no citation that supports it. This constitutes an unsupported factual claim with three misleading surrogate citations.

**Fix:** Remove `@cheng2021gazesurvey` from this sentence entirely (it belongs only to the preceding calibration-requirement sentence where it is correctly placed). Replace the VLM capability citation with a source that actually documents zero-shot / instruction-following classification by generative VLMs — for example a GPT-4V, Gemini, or general VLM capability paper. If no suitable citation is available, the capability claim must be framed as a design decision ("das entwickelte System nutzt Gemini 2.5 Flash für diese Aufgabe") without a citation that misattributes the evidence.

---

### CR-02: WIDER FACE benchmark paper cited for a speed-accuracy comparative claim it does not make

**File:** `T2000_Part1/chapters/fundamentals-1.typ:13`

**Issue:** The sentence "Schnelle Detektoren wie BlazeFace erzielen auf frontalen, wenig okludierten Gesichtern vergleichbare Genauigkeit wie schwergewichtigere Modelle bei einem Bruchteil der Inferenzzeit @yang2016widerface[S.~1--2]" cites the WIDER FACE paper. WIDER FACE is a benchmark *dataset* paper: it introduces the dataset, labelling protocol, and evaluation splits. Pages 1–2 describe the dataset motivation and collection methodology. The paper does not compare fast vs. heavy detectors, does not report inference times, and does not claim that lightweight detectors achieve comparable accuracy to heavyweight ones. The citation cannot support this comparative claim.

**Fix:** Replace `@yang2016widerface` on this sentence with a source that actually makes the speed-accuracy comparison — for example `@bazarevsky2019blazeface` (the BlazeFace paper itself reports benchmark comparisons against heavier detectors) or a face detection survey. Alternatively, the claim can be attributed directly to the BlazeFace paper, which already contains accuracy comparisons at line 11.

---

### CR-03: beyondgoldfish cited for embedding-precision of atomic vs. composite chunks — not its subject

**File:** `T2000_Part1/chapters/practical-2.typ:36`

**Issue:** The sentence "Atomare Sätze liegen im Vektorraum präzise verortet, während ein zusammengesetzter Absatz das Embedding in mehrere Richtungen zieht und die Trefferquote der semantischen Suche senkt @xu2022beyondgoldfish[S.~1]" cites page 1 of the "Beyond Goldfish Memory" paper to support the claim that atomic sentences have better vector-space precision than composite paragraphs for RAG retrieval. The beyondgoldfish paper is about long-term open-domain conversation memory: it demonstrates that systems with summarization and retrieval outperform standard encoder-decoder models for long conversations. Its page 1 (abstract/introduction) discusses conversation coherence and memory over sessions. It contains no analysis of chunking granularity effects on embedding precision or semantic search recall. This claim is plausible RAG engineering practice, but this citation does not support it.

**Fix:** Either (a) replace with a citation that directly discusses chunking granularity and its effect on retrieval quality (e.g., from the DPR or RAG literature, or a dedicated RAG chunking study), or (b) remove the citation and mark the claim as "(eigene Beobachtung)" consistent with how similar empirical design decisions are marked elsewhere in Kap. 5.3.

---

## Warnings

### WR-01: EMA phrasing "eines einzelnen Besuchs" describes the wrong quantity for (0,8)^5

**File:** `T2000_Part1/chapters/practical-1.typ:120`

**Issue:** The sentence "Bei α = 0,2 reduziert sich der Einfluss eines einzelnen Besuchs nach fünf Besuchen auf unter (0,8)^5 ≈ 33 % des ursprünglichen Gewichts" contains a subtle mismatch between the phrase and the calculation. The expression (0,8)^5 = 0,328 correctly computes the residual weight of the *originally stored embedding* (before any update) after five successive EMA updates. It does not describe the weight of "a single visit's contribution" after five more visits. A single visit contributes α = 0,2 at the time of the visit; after five subsequent visits that contribution has decayed to α · (1−α)^5 = 0,2 · 0,328 ≈ 6,6 % — not 33 %. The underlying logic of the EMA is correct; only the phrasing is imprecise.

**Fix:**
```typst
Bei $alpha = 0","2$ reduziert sich das Gewicht des ursprünglich gespeicherten Embeddings
nach fünf weiteren Besuchen auf unter $(0{,}8)^5 approx 33~%$
```
This makes clear that (0,8)^5 is the residual of the original stored vector, which is what the sentence is actually computing.

---

### WR-02: Citation key "cheng2021gazesurvey" encodes arXiv preprint year; bib entry is the 2024 TPAMI publication

**File:** `T2000_Part1/user/sources.bib:85`

**Issue:** The BibTeX entry `@article{cheng2021gazesurvey, ..., year={2024}, journal={IEEE Transactions on Pattern Analysis and Machine Intelligence}}` was published in IEEE TPAMI in 2024 (vol. 46, no. 12, pp. 7509–7728). The citation key encodes "2021", which is the year of the arXiv preprint (eprint: 2104.12668). When Typst/BibTeX renders the citation, it will use `year=2024` from the bib entry, but the key itself reads as 2021 — causing inconsistency between the key used in source code and the year displayed in the bibliography. In an examination context, a reviewer comparing inline source references to the bibliography will notice the discrepancy.

**Fix:** Rename the key to `cheng2024gazesurvey` throughout sources.bib and in all three chapter files where it is cited (fundamentals-1.typ lines 17 and 19).

---

### WR-03: Citation key "liu2023lostinthemiddle" encodes arXiv preprint year; bib entry is the 2024 TACL publication

**File:** `T2000_Part1/user/sources.bib:221`

**Issue:** The BibTeX entry `@article{liu2023lostinthemiddle, ..., year={2024}, journal={Transactions of the Association for Computational Linguistics}}` was published in TACL volume 12 in 2024 (pp. 157–173). The key encodes "2023" (arXiv preprint: 2307.03172). Same key/year mismatch as WR-02.

**Fix:** Rename to `liu2024lostinthemiddle` throughout sources.bib and in the two chapter files where it appears (fundamentals-1.typ line 57, practical-2.typ line 40).

---

### WR-04: voigt2017gdpr declared as @article with publisher name in the journal field

**File:** `T2000_Part1/user/sources.bib:315`

**Issue:** The entry is declared as `@article` and has `journal = {Springer International Publishing}`. The work is a monograph (ISBN 978-3-319-57959-7, doi 10.1007/978-3-319-57959-7). "Springer International Publishing" is the publisher, not a journal name. Using `@article` with a publisher string as the journal field will render incorrectly in most citation styles.

**Fix:**
```bibtex
@book{voigt2017gdpr,
  title     = {The {EU} General Data Protection Regulation ({GDPR}): A Practical Guide},
  author    = {Voigt, Paul and von dem Bussche, Axel},
  year      = {2017},
  publisher = {Springer},
  address   = {Cham},
  doi       = {10.1007/978-3-319-57959-7}
}
```

---

### WR-05: SORT cited as the principle behind 120 px euclidean radius matching — SORT uses Kalman filter + Hungarian assignment

**File:** `T2000_Part1/chapters/practical-1.typ:75`

**Issue:** "Damit wird das zweistufige Tracking-Prinzip aus Kap.~4.3 (SORT @bewley2016sort[S.~1--3]) umgesetzt." The SORT algorithm (Bewley et al. 2016) is defined by two components: (1) a Kalman filter that predicts the next position of each track, and (2) Hungarian-algorithm assignment based on IoU between predicted and detected bounding boxes. The system's Stage 1 is a simple euclidean-distance threshold (120 px radius, closest-first). No Kalman filter, no IoU, no Hungarian algorithm is present. Attributing this design to SORT is an overstatement that mischaracterises what SORT is. The DeepSORT attribution on line 81 is similarly affected by this framing.

**Fix:** Either describe the position-matching as a simpler nearest-centroid approach ("ein positions-basierter Präfilter nach dem Nächster-Nachbar-Prinzip") or, if the connection to SORT is to be preserved, frame it as "angelehnt an das Grundprinzip des einstufigen Positions-Trackings in SORT" with the explicit caveat that the Kalman prediction step is omitted.

---

### WR-06: guo2021scrfd cited as the InsightFace framework reference for the buffalo_l embedding model

**File:** `T2000_Part1/chapters/practical-1.typ:42`

**Issue:** "Das eingesetzte Modell w600k_r50 --- bereitgestellt über das InsightFace-Framework @guo2021scrfd[S.~1] im buffalo_l-Modellpaket". The SCRFD paper (Sample and Computation Redistribution for Efficient Face Detection, Guo et al. 2021) is specifically about the SCRFD face *detector*, not about the InsightFace framework or the buffalo_l model pack. The buffalo_l embedding model (w600k_r50, ArcFace, 512-dim) is a separate artefact from the InsightFace project. Citing the SCRFD paper as the InsightFace framework reference conflates the face-detection component with the face-recognition component, and page 1 of the SCRFD paper does not describe the buffalo_l model.

**Fix:** If a citation for InsightFace as the serving framework is needed, cite the ArcFace paper `@deng2019arcface` (where the InsightFace project originates) or an InsightFace technical report if one is available. The SCRFD citation can be removed from this sentence, or its scope clarified: "Das Modellpaket buffalo_l ist Teil des InsightFace-Projekts, das unter anderem den SCRFD-Detektor @guo2021scrfd und das in dieser Arbeit genutzte w600k_r50-Embedding-Modell umfasst."

---

_Reviewed: 2026-07-18_
_Reviewer: Claude (gsd-code-reviewer)_
_Depth: standard_
