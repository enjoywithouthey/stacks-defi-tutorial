(define-fungible-token magic-beans)

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-amount-zero (err u101))
(define-constant err-mint-zero (err u102))

;; custom function to mint tokens, only available to the contract owner.
(define-public (mint (amount uint) (who principal))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (asserts! (> amount u0) err-mint-zero)
        ;; amount, who are unchecked, but we let the contrct owner mint to whoever
        ;; #[allow(unchecked_data)]
        (ft-mint? magic-beans amount who)
    )
)

;; custom function to transfer tokens
(define-public (transfer (amount uint) (sender principal) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender sender) err-owner-only)
        (asserts! (> amount u0) err-amount-zero)
        ;; recipient is unchecked. Anyone can send to anyone
        ;; #[allow(unchecked_data)]
        (ft-transfer? magic-beans amount sender recipient)
    )
)

;; custom function to get balance
(define-read-only (get-balance (who principal))
    (ft-get-balance magic-beans who)
)
