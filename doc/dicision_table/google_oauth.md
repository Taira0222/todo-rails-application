## google oauth テストケース
テストケース 1 ~ 4 は integration/devise/google_auth_test.rb で実施
テスト5～7 は display_test.rb で実施

| テストケース  | 1            | 2                        | 3                       | 4                                       | 5                        | 6                       | 7                                       | 
| ------------- | ------------ | ------------------------ | ----------------------- | --------------------------------------- | ------------------------ | ----------------------- | --------------------------------------- | 
| google認証    | 〇           | 〇                       | 〇                      | 〇                                      | ×                        | ×                       | ×                                       | 
| user.persist? | 〇           | ×                        | ×                       | ×                                       | N/A                      | N/A                     | N/A                                     | 
| http_reffer   | -            | signup_url               | login_url               | N/A                                     | signup_url               | login_url               | N/A                                     | 
| google 認証   | 成功         | 成功                     | 成功                    | 成功                                    | 失敗                     | 失敗                    | 失敗                                    | 
| 結果          | ログイン成功 | signup_urlへリダイレクト | login_urlへリダイレクト | new_user_registration_urlへリダイレクト | signup_urlへリダイレクト | login_urlへリダイレクト | new_user_registration_urlへリダイレクト | 