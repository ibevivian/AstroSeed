;; AstroSeed: Decentralized Crowdfunding for Space Exploration

;; Constants
(define-constant ERR_NOT_AUTHORIZED (err u100))
(define-constant ERR_PROJECT_NOT_FOUND (err u101))
(define-constant ERR_PROJECT_EXISTS (err u102))
(define-constant ERR_LOW_FUNDS (err u103))
(define-constant ERR_PAST_DEADLINE (err u104))
(define-constant ERR_FUNDING_TARGET_NOT_MET (err u105))
(define-constant ERR_INVALID_PARAMETERS (err u106))
(define-constant ERR_EXISTING_BACKERS (err u107))
(define-constant ERR_NO_EXTENSIONS_AVAILABLE (err u108))
(define-constant ERR_VOTING_ACTIVE (err u109))
(define-constant ERR_VOTE_REQUIREMENT_NOT_MET (err u110))

;; Configuration
(define-constant FUNDING_THRESHOLD u75) ;; 75% of the target
(define-constant MAX_EXTENSION_LENGTH u30)
(define-constant VOTING_DURATION u7)
(define-constant MIN_APPROVAL_PERCENTAGE u60) ;; 60% of votes must be in favor
(define-constant MIN_REQUIRED_VOTES u10) ;; At least 10 votes required

;; Data Maps
(define-map space-projects 
  { project-id: uint } 
  { 
    title: (string-ascii 50), 
    founder: principal, 
    funding-target: uint, 
    end-date: uint, 
    funds-raised: uint, 
    status-active: bool,
    extension-count: uint,
    voting-end-time: uint,
    vote-count: uint,
    positive-votes: uint
  }
)

(define-map project-backers 
  { project-id: uint, backer: principal } 
  { contribution: uint }
)

(define-map project-votes
  { project-id: uint, backer: principal }
  { approved: bool }
)

;; Variables
(define-data-var project-counter uint u0)

;; Helper function to check if a project exists
(define-private (does-project-exist (project-id uint))
  (is-some (map-get? space-projects { project-id: project-id }))
)

;; Helper function to calculate voting percentage
(define-private (calculate-approval-rate (positive-votes uint) (vote-count uint))
  (if (is-eq vote-count u0)
    u0
    (/ (* positive-votes u100) vote-count)
  )
)

;; Functions

;; Launch a new space project
(define-public (launch-project (title (string-ascii 50)) (funding-target uint) (end-date uint))
  (let (
    (project-id (+ (var-get project-counter) u1))
    (title-length (len title))
  )
    (asserts! (> end-date block-height) ERR_PAST_DEADLINE)
    (asserts! (> funding-target u0) ERR_LOW_FUNDS)
    (asserts! (and (> title-length u0) (<= title-length u50)) ERR_INVALID_PARAMETERS)
    (asserts! (is-none (map-get? space-projects { project-id: project-id })) ERR_PROJECT_EXISTS)
    (map-set space-projects
      { project-id: project-id }
      { 
        title: title, 
        founder: tx-sender, 
        funding-target: funding-target, 
        end-date: end-date, 
        funds-raised: u0, 
        status-active: true,
        extension-count: u0,
        voting-end-time: (+ end-date (* VOTING_DURATION u144)), ;; Assuming 144 blocks per day
        vote-count: u0,
        positive-votes: u0
      }
    )
    (var-set project-counter project-id)
    (ok project-id)
  )
)

