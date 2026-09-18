# Library API Contract

This document mirrors the mock data currently used by the Flutter app. Backend
can implement these endpoints without requiring UI changes.

## Endpoints

### `GET /library`

Returns the data needed for the Library landing page.

```json
{
  "subjects": [
    { "id": "subj-1", "title": "Công nghệ phần mềm" }
  ],
  "recentDocuments": [
    {
      "id": "doc-1",
      "title": "Báo cáo đồ án chuyên ngành trang web bán rượu",
      "thumbnail": "https://cdn.example.com/doc-1.jpg"
    }
  ],
  "savedDocuments": [
    {
      "id": "doc-1",
      "title": "Báo cáo đồ án chuyên ngành trang web bán rượu - Tresor de Levure",
      "thumbnail": "https://cdn.example.com/doc-1.jpg",
      "category": "Lập trình .NET",
      "school": "Trường Đại học Nông Lâm Tp. HCM",
      "pageCount": 19,
      "year": "2024/2025",
      "likeCount": 15,
      "commentCount": 3,
      "isLiked": false,
      "isBookmarked": false
    }
  ]
}
```

### `GET /library/subjects/{subjectId}`

Returns the data needed for a subject detail page.

```json
{
  "subjectId": "subj-1",
  "schoolName": "Trường Đại học Nông Lâm Tp. HCM",
  "subjectName": "Công nghệ phần mềm",
  "userCount": 16,
  "uploadedDocuments": [],
  "topLikedDocuments": [],
  "storedDocuments": []
}
```

`uploadedDocuments` and `topLikedDocuments` use `DocumentCompactModel`.
`storedDocuments` uses `DocumentSummaryModel`.

### `POST /documents/{id}/like`

Toggles or creates a like action for the current user.

```json
{ "success": true }
```

### `POST /documents/{id}/bookmark`

Toggles or creates a bookmark action for the current user.

```json
{ "success": true }
```

### `POST /documents/{id}/download`

Registers a download request. Backend can return a file URL later if needed.

```json
{ "success": true }
```

## Models

```ts
type FolderItem = {
  id: string;
  title: string;
};

type DocumentCompactModel = {
  id: string;
  title: string;
  thumbnail?: string | null;
};

type DocumentSummaryModel = {
  id: string;
  title: string;
  thumbnail?: string | null;
  category: string;
  school: string;
  pageCount: number;
  year: string;
  likeCount: number;
  commentCount: number;
  isLiked: boolean;
  isBookmarked: boolean;
};
```
