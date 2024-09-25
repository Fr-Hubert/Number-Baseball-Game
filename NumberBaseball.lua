-- 数字野球ゲーム

math.randomseed(os.time()) -- ランダムシード設定

-- ランダムな3桁の数字生成
function generateNumber()
    local digits = {}  -- 空の配列を作成し、ランダムな数字を保存する準備
    while #digits < 3 do  -- 配列の長さが3になるまで繰り返す
        local digit = math.random(0, 9)  -- 0から9の間でランダムな数字を生成
        if not contains(digits, digit) then  -- 数字がすでに配列にないか確認
            table.insert(digits, digit)  -- 重複がなければ配列に追加
        end
    end
    return digits  -- 最終的に生成された数字の配列を返す
end

-- 配列に数字が含まれているか確認する関数
function contains(arr, value)
    for _, v in ipairs(arr) do  -- 配列を繰り返し各要素を確認
        if v == value then  -- 現在の要素が探している値と一致するか確認
            return true  -- 一致すればtrueを返す
        end
    end
    return false  -- 配列をすべて確認しても一致する値がなければfalseを返す
end

-- ストライクとボールを計算する関数
function calculateScore(guess, answer)
    local strikes = 0  -- ストライク数を初期化
    local balls = 0    -- ボール数を初期化
    for i = 1, 3 do  -- 1から3まで繰り返す
        if guess[i] == answer[i] then  -- 同じ位置で値が一致するか確認
            strikes = strikes + 1  -- 一致すればストライク数を増加
        elseif contains(answer, guess[i]) then  -- 値は一致しているが位置は異なるか確認
            balls = balls + 1  -- 一致すればボール数を増加
        end
    end
    return strikes, balls  -- 最終的にストライクとボール数を返す
end

-- ゲームループ
local function playGame()
    local answer = generateNumber()  -- ランダムな3桁の数字生成
    local attempts = 0  -- 試行回数を初期化

    print("Welcome to the Number Baseball Game! Try to guess the 3-digit number.")

    while true do
        io.write("Enter a 3-digit number: ")
        local input = io.read()  -- ユーザー入力を受け取る
        
        -- 入力値の有効性チェック
        if #input ~= 3 then
            print("You must enter a 3-digit number.")
            goto continue  -- 有効でない場合はcontinueに移動
        end
        
        local guess = {}
        for i = 1, 3 do
            local digit = tonumber(input:sub(i, i))  -- 各桁の数字を抽出
            if contains(guess, digit) then  -- 重複チェック
                print("You cannot enter duplicate digits.")
                goto continue  -- 重複した場合はcontinueに移動
            end
            table.insert(guess, digit)  -- 推測配列に追加
        end
        
        attempts = attempts + 1  -- 試行回数を増加
        local strikes, balls = calculateScore(guess, answer)  -- ストライクとボールを計算
        
        print(strikes .. " Strike(s), " .. balls .. " Ball(s).")  -- 結果を出力
        
        if strikes == 3 then  -- 正解を当てた場合
            print("Congratulations! You guessed it in " .. attempts .. " attempts!")
            break  -- ゲーム終了
        end
        
        ::continue::  -- 繰り返しの始まりに戻る
    end
end

-- メインループ
while true do
    playGame()  -- ゲーム実行

    io.write("Do you want to play again? (yes/no): ")  -- 再ゲームの有無を尋ねる
    local response = io.read()  -- ユーザーの応答を入力として受け取る
    if response:lower() ~= "yes" then  -- 応答が"yes"でない場合
        print("Thank you for playing!")  -- 終了メッセージを出力
        break  -- ループ終了
    end
end
