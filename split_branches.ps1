$ErrorActionPreference = "Stop"

$CoreFiles = @(
    "lib/app.dart",
    "lib/core/constants/app_icons.dart",
    "lib/core/feat/notification/domain/entity/notification_model.dart",
    "lib/core/feat/notification/domain/repository/notification_repository.dart",
    "lib/core/feat/notification/domain/repository/mock_notification_repository.dart",
    "lib/core/feat/notification/logic/notification_bloc.dart",
    "lib/core/feat/notification/logic/notification_event.dart",
    "lib/core/feat/notification/logic/notification_state.dart",
    "lib/main.dart"
)

# 1. Backup current state
Write-Host "Backing up current state..."
git add .
git commit -m "Backup: Toàn bộ code chức năng notification đang chạy ổn"
git branch temp-backup-notification

# 2. Function to create branch and commit feature files
function Create-FeatureBranch {
    param(
        [string]$branchName,
        [string[]]$featureFiles
    )
    Write-Host "Creating branch $branchName..."
    git checkout ver2/feature
    git checkout -b $branchName

    # Checkout core files
    foreach ($file in $CoreFiles) {
        git checkout temp-backup-notification -- $file
    }

    # Checkout feature files
    foreach ($file in $featureFiles) {
        git checkout temp-backup-notification -- $file
    }

    git add .
    git commit -m "feat: Add $branchName UI"
}

# 3. Create Branches
Create-FeatureBranch "feature/notification-header" @(
    "lib/core/feat/notification/presentation/notification_presentation.dart"
)

Create-FeatureBranch "feature/notification-notice" @(
    "lib/core/feat/notification/presentation/widgets/active_notification_list.dart",
    "lib/core/feat/notification/presentation/widgets/notification_item.dart"
)

Create-FeatureBranch "feature/notification-notice-seen" @(
    "lib/core/feat/notification/presentation/widgets/active_notification_list.dart",
    "lib/core/feat/notification/presentation/widgets/notification_item.dart"
)

Create-FeatureBranch "feature/notification-detail" @(
    "lib/core/feat/notification/presentation/widgets/notification_options_bottom_sheet.dart",
    "assets/icons/noti_markasread.png",
    "assets/icons/noti_trash.png"
)

Create-FeatureBranch "feature/notification-mark-all-read" @(
    "lib/core/feat/notification/presentation/widgets/global_notification_options_bottom_sheet.dart"
)

Create-FeatureBranch "feature/notification-trash" @(
    "lib/core/feat/notification/presentation/widgets/trash_notification_item.dart",
    "lib/core/feat/notification/presentation/widgets/trash_notification_list.dart"
)

Create-FeatureBranch "feature/notification-trash-bulk" @(
    "lib/core/feat/notification/presentation/widgets/trash_notification_list.dart",
    "assets/icons/noti_restore.png"
)

# 4. Restore user's current original state
Write-Host "Restoring original state..."
git checkout core/widgets/feat/notification
git reset temp-backup-notification~1

Write-Host "Done! Branches created successfully."
