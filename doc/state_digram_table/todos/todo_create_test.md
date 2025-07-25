## 状態遷移表の状態
| 状態番号 | 状態名                                      | 
| -------- | ------------------------------------------- | 
| 1        | 初期画面(today or upcoming or archived画面) | 
| 2        | todo 作成画面                               | 
| 3        | todo 作成画面(バリデーションエラー表示)           | 
| 4        | todoの日付に該当する画面                    | 


## 状態遷移表

| イベント \ 状態遷移後           | 1   | 2   | 3   | 4   | 
| ------------------------------- | :-- | :-- | --- | --- | 
| todo を追加ボタン               | N/A | 1,4 | N/A | N/A | 
| キャンセルボタン                | 2,3 | N/A | N/A | N/A | 
| 追加（バリデーションエラー）    | N/A | N/A | 2,3 | N/A | 
| 追加（正常・日付／source 合致） | 2,3 | N/A | N/A | N/A | 
| 追加（正常・日付／source ずれ） | N/A | N/A | N/A | 2,3 | 

## 実行するべきテストケース
遷移前　→　遷移後　/ (イベント)

- [x] 初期画面 → todo 作成画面　/ (todo を追加ボタン)
- [x] todoの日付に該当する画面 → todo 作成画面　/ (todo を追加ボタン)

- [x] todo 作成画面 → 初期画面　(キャンセルボタン)
- [] todo 作成画面(バリデーションエラー表示)  → 初期画面　/ (キャンセルボタン)

- [] todo 作成画面 → todo 作成画面(バリデーションエラー表示) / (追加（バリデーションエラー）)
- [] todo 作成画面(バリデーションエラー表示) → todo 作成画面(バリデーションエラー表示) / (追加（バリデーションエラー）)

- [x] todo 作成画面 →  初期画面 / (追加（正常・日付／source 合致）)
- [] todo 作成画面(バリデーションエラー表示) → 初期画面 / (追加（正常・日付／source 合致）)

- [x] todo 作成画面 →  todoの日付に該当する画面   / (追加（正常・日付／source ずれ）)
- [] todo 作成画面(バリデーションエラー表示) → todoの日付に該当する画面   / (追加（正常・日付／source ずれ）)