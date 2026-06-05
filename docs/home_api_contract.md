# Home Documents API Contract

Home currently consumes this API directly for the paginated feed.

## `GET /documents?page=1&pageSize=5`

Rules:

- `page` defaults to `1`.
- `pageSize` defaults to `5`.
- `pageSize` max is `50`.
- Only return documents with status `READY`.

Response:

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "title": "De cuong Co so du lieu 2025",
        "thumbnail": "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&h=600&fit=crop",
        "category": "Co so du lieu",
        "school": "Dai hoc Bach khoa Ha Noi",
        "pageCount": 19,
        "year": "2025/2026",
        "likeCount": 15,
        "commentCount": 3,
        "isLiked": false,
        "isBookmarked": false
      }
    ],
    "page": 1,
    "pageSize": 5,
    "total": 7,
    "hasMore": true
  },
  "timestamp": "2026-06-05T14:00:00Z"
}
```

## FE Model

```ts
type DocumentsPage = {
  items: DocumentSummaryModel[];
  page: number;
  pageSize: number;
  total: number;
  hasMore: boolean;
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
