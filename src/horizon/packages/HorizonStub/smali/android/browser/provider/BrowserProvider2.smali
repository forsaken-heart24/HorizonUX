.class public Lcom/android/browser/provider/BrowserProvider2;
.super Lcom/android/browser/provider/SQLiteContentProvider;
.source "BrowserProvider2.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/android/browser/provider/BrowserProvider2$SuggestionsCursor;,
        Lcom/android/browser/provider/BrowserProvider2$DatabaseHelper;
    }
.end annotation


# static fields
.field static final ACCOUNTS_PROJECTION_MAP:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field static final BOOKMARKS_PROJECTION_MAP:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field static final COMBINED_BOOKMARK_PROJECTION_MAP:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field static final COMBINED_HISTORY_PROJECTION_MAP:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field static final HISTORY_PROJECTION_MAP:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field static final IMAGES_PROJECTION_MAP:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field static final LEGACY_AUTHORITY_URI:Landroid/net/Uri;

.field static final OTHER_BOOKMARKS_PROJECTION_MAP:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field static final SEARCHES_PROJECTION_MAP:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field static final SETTINGS_PROJECTION_MAP:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private static final SUGGEST_PROJECTION:[Ljava/lang/String;

.field static final SYNC_STATE_PROJECTION_MAP:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field static final URI_MATCHER:Landroid/content/UriMatcher;


# instance fields
.field mOpenHelper:Lcom/android/browser/provider/BrowserProvider2$DatabaseHelper;


# direct methods
.method static constructor <clinit>()V
    .locals 16

    .line 60
    new-instance v0, Landroid/net/Uri$Builder;

    invoke-direct {v0}, Landroid/net/Uri$Builder;-><init>()V

    const-string v1, "browser"

    .line 61
    invoke-virtual {v0, v1}, Landroid/net/Uri$Builder;->authority(Ljava/lang/String;)Landroid/net/Uri$Builder;

    move-result-object v0

    const-string v2, "content"

    invoke-virtual {v0, v2}, Landroid/net/Uri$Builder;->scheme(Ljava/lang/String;)Landroid/net/Uri$Builder;

    move-result-object v0

    invoke-virtual {v0}, Landroid/net/Uri$Builder;->build()Landroid/net/Uri;

    move-result-object v0

    sput-object v0, Lcom/android/browser/provider/BrowserProvider2;->LEGACY_AUTHORITY_URI:Landroid/net/Uri;

    const/4 v0, 0x5

    new-array v0, v0, [Ljava/lang/String;

    const-string v2, "history"

    const-string v3, "_id"

    .line 111
    invoke-static {v2, v3}, Lcom/android/browser/provider/BrowserProvider2;->qualifyColumn(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const/4 v5, 0x0

    aput-object v4, v0, v5

    const-string v4, "url"

    .line 112
    invoke-static {v2, v4}, Lcom/android/browser/provider/BrowserProvider2;->qualifyColumn(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    const/4 v7, 0x1

    aput-object v6, v0, v7

    const-string v6, "title"

    .line 113
    invoke-static {v6}, Lcom/android/browser/provider/BrowserProvider2;->bookmarkOrHistoryColumn(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    const/4 v8, 0x2

    aput-object v7, v0, v8

    .line 115
    invoke-static {v5}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v7

    .line 116
    invoke-static {v5}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v5

    .line 114
    invoke-static {v4, v7, v5}, Lcom/android/browser/provider/BrowserProvider2;->bookmarkOrHistoryLiteral(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    const/4 v7, 0x3

    aput-object v5, v0, v7

    const-string v5, "date"

    .line 117
    invoke-static {v2, v5}, Lcom/android/browser/provider/BrowserProvider2;->qualifyColumn(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    const/4 v8, 0x4

    aput-object v7, v0, v8

    sput-object v0, Lcom/android/browser/provider/BrowserProvider2;->SUGGEST_PROJECTION:[Ljava/lang/String;

    .line 172
    new-instance v0, Landroid/content/UriMatcher;

    const/4 v7, -0x1

    invoke-direct {v0, v7}, Landroid/content/UriMatcher;-><init>(I)V

    sput-object v0, Lcom/android/browser/provider/BrowserProvider2;->URI_MATCHER:Landroid/content/UriMatcher;

    .line 174
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/android/browser/provider/BrowserProvider2;->ACCOUNTS_PROJECTION_MAP:Ljava/util/HashMap;

    .line 175
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/android/browser/provider/BrowserProvider2;->BOOKMARKS_PROJECTION_MAP:Ljava/util/HashMap;

    .line 176
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/android/browser/provider/BrowserProvider2;->OTHER_BOOKMARKS_PROJECTION_MAP:Ljava/util/HashMap;

    .line 178
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/android/browser/provider/BrowserProvider2;->HISTORY_PROJECTION_MAP:Ljava/util/HashMap;

    .line 179
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/android/browser/provider/BrowserProvider2;->SYNC_STATE_PROJECTION_MAP:Ljava/util/HashMap;

    .line 180
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/android/browser/provider/BrowserProvider2;->IMAGES_PROJECTION_MAP:Ljava/util/HashMap;

    .line 181
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/android/browser/provider/BrowserProvider2;->COMBINED_HISTORY_PROJECTION_MAP:Ljava/util/HashMap;

    .line 182
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/android/browser/provider/BrowserProvider2;->COMBINED_BOOKMARK_PROJECTION_MAP:Ljava/util/HashMap;

    .line 183
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/android/browser/provider/BrowserProvider2;->SEARCHES_PROJECTION_MAP:Ljava/util/HashMap;

    .line 184
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/android/browser/provider/BrowserProvider2;->SETTINGS_PROJECTION_MAP:Ljava/util/HashMap;

    .line 187
    sget-object v0, Lcom/android/browser/provider/BrowserProvider2;->URI_MATCHER:Landroid/content/UriMatcher;

    const-string v7, "com.android.browser"

    const-string v8, "accounts"

    const/16 v9, 0x1b58

    .line 189
    invoke-virtual {v0, v7, v8, v9}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v8, "bookmarks"

    const/16 v9, 0x3e8

    .line 190
    invoke-virtual {v0, v7, v8, v9}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v9, "bookmarks/#"

    const/16 v10, 0x3e9

    .line 191
    invoke-virtual {v0, v7, v9, v10}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v10, "bookmarks/folder"

    const/16 v11, 0x3ea

    .line 192
    invoke-virtual {v0, v7, v10, v11}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v10, "bookmarks/folder/#"

    const/16 v11, 0x3eb

    .line 193
    invoke-virtual {v0, v7, v10, v11}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v10, "bookmarks/folder/id"

    const/16 v11, 0x3ed

    .line 194
    invoke-virtual {v0, v7, v10, v11}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v10, "search_suggest_query"

    const/16 v11, 0x3ec

    .line 195
    invoke-virtual {v0, v7, v10, v11}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v12, "bookmarks/search_suggest_query"

    .line 198
    invoke-virtual {v0, v7, v12, v11}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const/16 v13, 0x7d0

    .line 201
    invoke-virtual {v0, v7, v2, v13}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v13, "history/#"

    const/16 v14, 0x7d1

    .line 202
    invoke-virtual {v0, v7, v13, v14}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v13, "searches"

    const/16 v14, 0xbb8

    .line 203
    invoke-virtual {v0, v7, v13, v14}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v13, "searches/#"

    const/16 v14, 0xbb9

    .line 204
    invoke-virtual {v0, v7, v13, v14}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v13, "syncstate"

    const/16 v14, 0xfa0

    .line 205
    invoke-virtual {v0, v7, v13, v14}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v13, "syncstate/#"

    const/16 v14, 0xfa1

    .line 206
    invoke-virtual {v0, v7, v13, v14}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v13, "images"

    const/16 v14, 0x1388

    .line 207
    invoke-virtual {v0, v7, v13, v14}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v13, "combined"

    const/16 v14, 0x1770

    .line 208
    invoke-virtual {v0, v7, v13, v14}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v13, "combined/#"

    const/16 v14, 0x1771

    .line 209
    invoke-virtual {v0, v7, v13, v14}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v13, "settings"

    const/16 v14, 0x1f40

    .line 210
    invoke-virtual {v0, v7, v13, v14}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v13, "thumbnails"

    const/16 v14, 0xa

    .line 211
    invoke-virtual {v0, v7, v13, v14}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v13, "thumbnails/#"

    const/16 v14, 0xb

    .line 212
    invoke-virtual {v0, v7, v13, v14}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v13, "omnibox_suggestions"

    const/16 v14, 0x14

    .line 213
    invoke-virtual {v0, v7, v13, v14}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v7, "searches"

    const/16 v13, 0xbb8

    .line 216
    invoke-virtual {v0, v1, v7, v13}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const-string v7, "searches/#"

    const/16 v13, 0xbb9

    .line 217
    invoke-virtual {v0, v1, v7, v13}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const/16 v7, 0x2328

    .line 218
    invoke-virtual {v0, v1, v8, v7}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    const/16 v7, 0x2329

    .line 219
    invoke-virtual {v0, v1, v9, v7}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    .line 220
    invoke-virtual {v0, v1, v10, v11}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    .line 223
    invoke-virtual {v0, v1, v12, v11}, Landroid/content/UriMatcher;->addURI(Ljava/lang/String;Ljava/lang/String;I)V

    .line 231
    sget-object v0, Lcom/android/browser/provider/BrowserProvider2;->ACCOUNTS_PROJECTION_MAP:Ljava/util/HashMap;

    const-string v1, "account_type"

    .line 232
    invoke-virtual {v0, v1, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v7, "account_name"

    .line 233
    invoke-virtual {v0, v7, v7}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v9, "root_id"

    const-string v10, "root_id"

    .line 234
    invoke-virtual {v0, v9, v10}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 237
    sget-object v0, Lcom/android/browser/provider/BrowserProvider2;->BOOKMARKS_PROJECTION_MAP:Ljava/util/HashMap;

    .line 238
    invoke-static {v8, v3}, Lcom/android/browser/provider/BrowserProvider2;->qualifyColumn(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v0, v3, v8}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 239
    invoke-virtual {v0, v6, v6}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 240
    invoke-virtual {v0, v4, v4}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v8, "favicon"

    .line 241
    invoke-virtual {v0, v8, v8}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v9, "thumbnail"

    .line 242
    invoke-virtual {v0, v9, v9}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v10, "touch_icon"

    .line 243
    invoke-virtual {v0, v10, v10}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v11, "folder"

    const-string v12, "folder"

    .line 244
    invoke-virtual {v0, v11, v12}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v11, "parent"

    const-string v12, "parent"

    .line 245
    invoke-virtual {v0, v11, v12}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v11, "position"

    .line 246
    invoke-virtual {v0, v11, v11}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v12, "insert_after"

    const-string v13, "insert_after"

    .line 247
    invoke-virtual {v0, v12, v13}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v12, "deleted"

    const-string v13, "deleted"

    .line 248
    invoke-virtual {v0, v12, v13}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 249
    invoke-virtual {v0, v7, v7}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 250
    invoke-virtual {v0, v1, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v12, "sourceid"

    const-string v13, "sourceid"

    .line 251
    invoke-virtual {v0, v12, v13}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v12, "version"

    const-string v13, "version"

    .line 252
    invoke-virtual {v0, v12, v13}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v12, "created"

    .line 253
    invoke-virtual {v0, v12, v12}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v13, "modified"

    const-string v14, "modified"

    .line 254
    invoke-virtual {v0, v13, v14}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v13, "dirty"

    const-string v14, "dirty"

    .line 255
    invoke-virtual {v0, v13, v14}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v13, "sync1"

    const-string v14, "sync1"

    .line 256
    invoke-virtual {v0, v13, v14}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v13, "sync2"

    const-string v14, "sync2"

    .line 257
    invoke-virtual {v0, v13, v14}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v13, "sync3"

    const-string v14, "sync3"

    .line 258
    invoke-virtual {v0, v13, v14}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v13, "sync4"

    const-string v14, "sync4"

    .line 259
    invoke-virtual {v0, v13, v14}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v13, "sync5"

    const-string v14, "sync5"

    .line 260
    invoke-virtual {v0, v13, v14}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v13, "parent_source"

    const-string v14, "(SELECT sourceid FROM bookmarks A WHERE A._id=bookmarks.parent) AS parent_source"

    .line 261
    invoke-virtual {v0, v13, v14}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v13, "insert_after_source"

    const-string v14, "(SELECT sourceid FROM bookmarks A WHERE A._id=bookmarks.insert_after) AS insert_after_source"

    .line 265
    invoke-virtual {v0, v13, v14}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v13, "type"

    const-string v14, "CASE  WHEN folder=0 THEN 1 WHEN sync3=\'bookmark_bar\' THEN 3 WHEN sync3=\'other_bookmarks\' THEN 4 ELSE 2 END AS type"

    .line 269
    invoke-virtual {v0, v13, v14}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 282
    sget-object v0, Lcom/android/browser/provider/BrowserProvider2;->OTHER_BOOKMARKS_PROJECTION_MAP:Ljava/util/HashMap;

    sget-object v13, Lcom/android/browser/provider/BrowserProvider2;->BOOKMARKS_PROJECTION_MAP:Ljava/util/HashMap;

    invoke-virtual {v0, v13}, Ljava/util/HashMap;->putAll(Ljava/util/Map;)V

    .line 283
    sget-object v0, Lcom/android/browser/provider/BrowserProvider2;->OTHER_BOOKMARKS_PROJECTION_MAP:Ljava/util/HashMap;

    new-instance v13, Ljava/lang/StringBuilder;

    invoke-direct {v13}, Ljava/lang/StringBuilder;-><init>()V

    const-wide v14, 0x7fffffffffffffffL

    .line 284
    invoke-static {v14, v15}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v14

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v14, " AS "

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v13

    .line 283
    invoke-virtual {v0, v11, v13}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 287
    sget-object v0, Lcom/android/browser/provider/BrowserProvider2;->HISTORY_PROJECTION_MAP:Ljava/util/HashMap;

    .line 288
    invoke-static {v2, v3}, Lcom/android/browser/provider/BrowserProvider2;->qualifyColumn(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v0, v3, v11}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 289
    invoke-virtual {v0, v6, v6}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 290
    invoke-virtual {v0, v4, v4}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 291
    invoke-virtual {v0, v8, v8}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 292
    invoke-virtual {v0, v9, v9}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 293
    invoke-virtual {v0, v10, v10}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 294
    invoke-virtual {v0, v12, v12}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 295
    invoke-virtual {v0, v5, v5}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v11, "visits"

    .line 296
    invoke-virtual {v0, v11, v11}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v13, "user_entered"

    .line 297
    invoke-virtual {v0, v13, v13}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 300
    sget-object v0, Lcom/android/browser/provider/BrowserProvider2;->SYNC_STATE_PROJECTION_MAP:Ljava/util/HashMap;

    .line 301
    invoke-virtual {v0, v3, v3}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 302
    invoke-virtual {v0, v7, v7}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 303
    invoke-virtual {v0, v1, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v1, "data"

    const-string v7, "data"

    .line 304
    invoke-virtual {v0, v1, v7}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 307
    sget-object v0, Lcom/android/browser/provider/BrowserProvider2;->IMAGES_PROJECTION_MAP:Ljava/util/HashMap;

    const-string v1, "url_key"

    const-string v7, "url_key"

    .line 308
    invoke-virtual {v0, v1, v7}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 309
    invoke-virtual {v0, v8, v8}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 310
    invoke-virtual {v0, v9, v9}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 311
    invoke-virtual {v0, v10, v10}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 314
    sget-object v0, Lcom/android/browser/provider/BrowserProvider2;->COMBINED_HISTORY_PROJECTION_MAP:Ljava/util/HashMap;

    .line 315
    invoke-static {v3}, Lcom/android/browser/provider/BrowserProvider2;->bookmarkOrHistoryColumn(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v3, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 316
    invoke-static {v6}, Lcom/android/browser/provider/BrowserProvider2;->bookmarkOrHistoryColumn(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v6, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 317
    invoke-static {v2, v4}, Lcom/android/browser/provider/BrowserProvider2;->qualifyColumn(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v4, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 318
    invoke-static {v2, v12}, Lcom/android/browser/provider/BrowserProvider2;->qualifyColumn(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v12, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 319
    invoke-virtual {v0, v5, v5}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v1, "bookmark"

    const-string v2, "CASE WHEN bookmarks._id IS NOT NULL THEN 1 ELSE 0 END AS bookmark"

    .line 320
    invoke-virtual {v0, v1, v2}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 323
    invoke-virtual {v0, v11, v11}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 324
    invoke-virtual {v0, v8, v8}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 325
    invoke-virtual {v0, v9, v9}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 326
    invoke-virtual {v0, v10, v10}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v1, "NULL AS user_entered"

    .line 327
    invoke-virtual {v0, v13, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 330
    sget-object v0, Lcom/android/browser/provider/BrowserProvider2;->COMBINED_BOOKMARK_PROJECTION_MAP:Ljava/util/HashMap;

    .line 331
    invoke-virtual {v0, v3, v3}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 332
    invoke-virtual {v0, v6, v6}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 333
    invoke-virtual {v0, v4, v4}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 334
    invoke-virtual {v0, v12, v12}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v1, "NULL AS date"

    .line 335
    invoke-virtual {v0, v5, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v1, "bookmark"

    const-string v2, "1 AS bookmark"

    .line 336
    invoke-virtual {v0, v1, v2}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v1, "0 AS visits"

    .line 337
    invoke-virtual {v0, v11, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 338
    invoke-virtual {v0, v8, v8}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 339
    invoke-virtual {v0, v9, v9}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 340
    invoke-virtual {v0, v10, v10}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v1, "NULL AS user_entered"

    .line 341
    invoke-virtual {v0, v13, v1}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 344
    sget-object v0, Lcom/android/browser/provider/BrowserProvider2;->SEARCHES_PROJECTION_MAP:Ljava/util/HashMap;

    .line 345
    invoke-virtual {v0, v3, v3}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v1, "search"

    const-string v2, "search"

    .line 346
    invoke-virtual {v0, v1, v2}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 347
    invoke-virtual {v0, v5, v5}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 350
    sget-object v0, Lcom/android/browser/provider/BrowserProvider2;->SETTINGS_PROJECTION_MAP:Ljava/util/HashMap;

    const-string v1, "key"

    const-string v2, "key"

    .line 351
    invoke-virtual {v0, v1, v2}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v1, "value"

    const-string v2, "value"

    .line 352
    invoke-virtual {v0, v1, v2}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 54
    invoke-direct {p0}, Lcom/android/browser/provider/SQLiteContentProvider;-><init>()V

    return-void
.end method

.method private appendBookmarksIfFolder(Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/Object;
    .locals 11

    .line 879
    iget-object v0, p0, Lcom/android/browser/provider/BrowserProvider2;->mOpenHelper:Lcom/android/browser/provider/BrowserProvider2$DatabaseHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getReadableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v1

    const-string v0, "_id"

    const-string v2, "folder"

    .line 880
    filled-new-array {v0, v2}, [Ljava/lang/String;

    move-result-object v3

    .line 884
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, p1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 885
    new-instance v9, Ljava/util/ArrayList;

    invoke-direct {v9}, Ljava/util/ArrayList;-><init>()V

    const/4 v10, 0x0

    :try_start_0
    const-string v2, "bookmarks"

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    move-object v4, p1

    move-object v5, p2

    .line 889
    invoke-virtual/range {v1 .. v8}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v10

    const/4 p1, 0x0

    const/4 p2, 0x1

    if-eqz v10, :cond_2

    .line 892
    :cond_0
    :goto_0
    invoke-interface {v10}, Landroid/database/Cursor;->moveToNext()Z

    move-result v1

    if-eqz v1, :cond_2

    .line 893
    invoke-interface {v10, p1}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v1

    invoke-static {v1, v2}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v1

    .line 894
    invoke-interface {v9, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 895
    invoke-interface {v10, p2}, Landroid/database/Cursor;->getInt(I)I

    move-result v2

    if-eqz v2, :cond_0

    const-string v2, "parent=?"

    new-array v3, p2, [Ljava/lang/String;

    aput-object v1, v3, p1

    .line 897
    invoke-direct {p0, v2, v3}, Lcom/android/browser/provider/BrowserProvider2;->appendBookmarksIfFolder(Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/Object;

    move-result-object v1

    .line 899
    aget-object v1, v1, p2

    check-cast v1, [Ljava/lang/String;

    .line 900
    array-length v2, v1

    if-lez v2, :cond_0

    const-string v2, " OR bookmarks._id IN ("

    .line 901
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 902
    array-length v2, v1

    move v3, p1

    :goto_1
    if-ge v3, v2, :cond_1

    aget-object v4, v1, v3

    const-string v5, "?,"

    .line 903
    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 904
    invoke-interface {v9, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    .line 906
    :cond_1
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v1

    sub-int/2addr v1, p2

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->deleteCharAt(I)Ljava/lang/StringBuilder;

    const-string v1, ")"

    .line 907
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    :cond_2
    if-eqz v10, :cond_3

    .line 914
    invoke-interface {v10}, Landroid/database/Cursor;->close()V

    :cond_3
    const/4 p0, 0x2

    new-array p0, p0, [Ljava/lang/Object;

    .line 919
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    aput-object v0, p0, p1

    .line 920
    invoke-interface {v9}, Ljava/util/List;->size()I

    move-result p1

    new-array p1, p1, [Ljava/lang/String;

    invoke-interface {v9, p1}, Ljava/util/List;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object p1

    aput-object p1, p0, p2

    return-object p0

    :catchall_0
    move-exception p0

    if-eqz v10, :cond_4

    .line 914
    invoke-interface {v10}, Landroid/database/Cursor;->close()V

    .line 916
    :cond_4
    throw p0
.end method

.method static final bookmarkOrHistoryColumn(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    .line 356
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "CASE WHEN bookmarks."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " IS NOT NULL THEN bookmarks."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " ELSE history."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " END AS "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static final bookmarkOrHistoryLiteral(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    .line 362
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "CASE WHEN bookmarks."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " IS NOT NULL THEN \""

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "\" ELSE \""

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "\" END"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private createCombinedQuery(Landroid/net/Uri;[Ljava/lang/String;Landroid/database/sqlite/SQLiteQueryBuilder;)[Ljava/lang/String;
    .locals 12

    .line 818
    new-instance p2, Ljava/lang/StringBuilder;

    const/16 v0, 0x80

    invoke-direct {p2, v0}, Ljava/lang/StringBuilder;-><init>(I)V

    const-string v0, "deleted"

    .line 819
    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " = 0"

    .line 820
    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v0, 0x0

    .line 822
    invoke-virtual {p0, p1, v0, v0}, Lcom/android/browser/provider/BrowserProvider2;->getSelectionWithAccounts(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/Object;

    move-result-object p0

    const/4 p1, 0x0

    .line 823
    aget-object v1, p0, p1

    check-cast v1, Ljava/lang/String;

    const/4 v2, 0x1

    .line 824
    aget-object p0, p0, v2

    check-cast p0, [Ljava/lang/String;

    const/4 v3, 0x2

    if-eqz v1, :cond_0

    .line 826
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, " AND "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz p0, :cond_0

    .line 829
    array-length v1, p0

    mul-int/2addr v1, v3

    new-array v1, v1, [Ljava/lang/String;

    .line 830
    array-length v4, p0

    invoke-static {p0, p1, v1, p1, v4}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 831
    array-length v4, p0

    array-length v5, p0

    invoke-static {p0, p1, v1, v4, v5}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    goto :goto_0

    :cond_0
    move-object v1, v0

    .line 835
    :goto_0
    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p2, "bookmarks"

    .line 837
    invoke-virtual {p3, p2}, Landroid/database/sqlite/SQLiteQueryBuilder;->setTables(Ljava/lang/String;)V

    const/4 v5, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    const/4 v9, 0x0

    const/4 v10, 0x0

    move-object v4, p3

    move-object v6, p0

    .line 838
    invoke-virtual/range {v4 .. v10}, Landroid/database/sqlite/SQLiteQueryBuilder;->buildQuery([Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    new-array v4, v2, [Ljava/lang/Object;

    aput-object p2, v4, p1

    const-string p2, "history LEFT OUTER JOIN (%s) bookmarks ON history.url = bookmarks.url LEFT OUTER JOIN images ON history.url = images.url_key"

    .line 840
    invoke-static {p2, v4}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p3, p2}, Landroid/database/sqlite/SQLiteQueryBuilder;->setTables(Ljava/lang/String;)V

    .line 841
    sget-object p2, Lcom/android/browser/provider/BrowserProvider2;->COMBINED_HISTORY_PROJECTION_MAP:Ljava/util/HashMap;

    invoke-virtual {p3, p2}, Landroid/database/sqlite/SQLiteQueryBuilder;->setProjectionMap(Ljava/util/Map;)V

    const/4 v6, 0x0

    move-object v4, p3

    .line 842
    invoke-virtual/range {v4 .. v10}, Landroid/database/sqlite/SQLiteQueryBuilder;->buildQuery([Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    const-string v4, "bookmarks LEFT OUTER JOIN images ON bookmarks.url = images.url_key"

    .line 845
    invoke-virtual {p3, v4}, Landroid/database/sqlite/SQLiteQueryBuilder;->setTables(Ljava/lang/String;)V

    .line 846
    sget-object v4, Lcom/android/browser/provider/BrowserProvider2;->COMBINED_BOOKMARK_PROJECTION_MAP:Ljava/util/HashMap;

    invoke-virtual {p3, v4}, Landroid/database/sqlite/SQLiteQueryBuilder;->setProjectionMap(Ljava/util/Map;)V

    .line 847
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 p0, 0x3

    new-array p0, p0, [Ljava/lang/Object;

    const-string v5, "url"

    aput-object v5, p0, p1

    aput-object v5, p0, v2

    const-string v5, "history"

    aput-object v5, p0, v3

    const-string v5, " AND %s NOT IN (SELECT %s FROM %s)"

    invoke-static {v5, p0}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    const/4 v11, 0x0

    move-object v5, p3

    .line 849
    invoke-virtual/range {v5 .. v11}, Landroid/database/sqlite/SQLiteQueryBuilder;->buildQuery([Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    new-array v3, v3, [Ljava/lang/String;

    aput-object p2, v3, p1

    aput-object p0, v3, v2

    .line 852
    invoke-virtual {p3, v3, v0, v0}, Landroid/database/sqlite/SQLiteQueryBuilder;->buildUnionQuery([Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    .line 855
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p2, "("

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p3, p0}, Landroid/database/sqlite/SQLiteQueryBuilder;->setTables(Ljava/lang/String;)V

    .line 856
    invoke-virtual {p3, v0}, Landroid/database/sqlite/SQLiteQueryBuilder;->setProjectionMap(Ljava/util/Map;)V

    return-object v1
.end method

.method private doSuggestQuery(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;
    .locals 9

    const/4 p3, 0x0

    .line 785
    aget-object v0, p2, p3

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 p1, 0x0

    const-string p2, "history.date != 0"

    move-object v4, p1

    move-object v3, p2

    goto/16 :goto_2

    .line 789
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    aget-object v1, p2, p3

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "%"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 790
    aget-object v1, p2, p3

    const-string v2, "http"

    invoke-virtual {v1, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_2

    aget-object v1, p2, p3

    const-string v2, "file"

    .line 791
    invoke-virtual {v1, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    goto :goto_0

    :cond_1
    const/4 p1, 0x6

    new-array p2, p1, [Ljava/lang/String;

    .line 795
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "http://"

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    aput-object p1, p2, p3

    const/4 p1, 0x1

    .line 796
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "http://www."

    invoke-virtual {p3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    aput-object p3, p2, p1

    const/4 p1, 0x2

    .line 797
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "https://"

    invoke-virtual {p3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    aput-object p3, p2, p1

    const/4 p1, 0x3

    .line 798
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "https://www."

    invoke-virtual {p3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    aput-object p3, p2, p1

    const/4 p1, 0x4

    aput-object v0, p2, p1

    const/4 p1, 0x5

    aput-object v0, p2, p1

    const-string p1, "history.url LIKE ? OR history.url LIKE ? OR history.url LIKE ? OR history.url LIKE ? OR history.title LIKE ? OR bookmarks.title LIKE ?"

    goto :goto_1

    .line 792
    :cond_2
    :goto_0
    aput-object v0, p2, p3

    :goto_1
    const-string p3, "deleted=0 AND folder=0"

    .line 804
    invoke-static {p1, p3}, Landroid/database/DatabaseUtils;->concatenateWhere(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    move-object v3, p1

    move-object v4, p2

    .line 808
    :goto_2
    iget-object p0, p0, Lcom/android/browser/provider/BrowserProvider2;->mOpenHelper:Lcom/android/browser/provider/BrowserProvider2$DatabaseHelper;

    invoke-virtual {p0}, Landroid/database/sqlite/SQLiteOpenHelper;->getReadableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    sget-object v2, Lcom/android/browser/provider/BrowserProvider2;->SUGGEST_PROJECTION:[Ljava/lang/String;

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    const-string v1, "history LEFT OUTER JOIN bookmarks ON history.url = bookmarks.url"

    invoke-virtual/range {v0 .. v8}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p0

    .line 812
    new-instance p1, Lcom/android/browser/provider/BrowserProvider2$SuggestionsCursor;

    invoke-direct {p1, p0}, Lcom/android/browser/provider/BrowserProvider2$SuggestionsCursor;-><init>(Landroid/database/Cursor;)V

    return-object p1
.end method

.method private filterSearchClient(Ljava/lang/String;)Ljava/lang/String;
    .locals 2

    const-string p0, "client="

    .line 1233
    invoke-virtual {p1, p0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result p0

    if-lez p0, :cond_1

    const-string v0, ".google."

    .line 1234
    invoke-virtual {p1, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_1

    const/16 v0, 0x26

    .line 1235
    invoke-virtual {p1, v0, p0}, Ljava/lang/String;->indexOf(II)I

    move-result v0

    const/4 v1, 0x0

    if-lez v0, :cond_0

    .line 1237
    invoke-virtual {p1, v1, p0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    add-int/lit8 v0, v0, 0x1

    .line 1238
    invoke-virtual {p1, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    goto :goto_0

    :cond_0
    add-int/lit8 p0, p0, -0x1

    .line 1241
    invoke-virtual {p1, v1, p0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p1

    :cond_1
    :goto_0
    return-object p1
.end method

.method private filterSearchClient([Ljava/lang/String;)V
    .locals 2

    if-eqz p1, :cond_0

    const/4 v0, 0x0

    .line 1223
    :goto_0
    array-length v1, p1

    if-ge v0, v1, :cond_0

    .line 1224
    aget-object v1, p1, v0

    invoke-direct {p0, v1}, Lcom/android/browser/provider/BrowserProvider2;->filterSearchClient(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    aput-object v1, p1, v0

    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    :cond_0
    return-void
.end method

.method private getAccountNameAndType(J)[Ljava/lang/String;
    .locals 8

    const-wide/16 v0, 0x0

    cmp-long v0, p1, v0

    const/4 v1, 0x0

    if-gtz v0, :cond_0

    return-object v1

    .line 1184
    :cond_0
    sget-object v0, Landroid/provider/BrowserContract$Bookmarks;->CONTENT_URI:Landroid/net/Uri;

    invoke-static {v0, p1, p2}, Landroid/content/ContentUris;->withAppendedId(Landroid/net/Uri;J)Landroid/net/Uri;

    move-result-object v3

    const-string p1, "account_name"

    const-string p2, "account_type"

    .line 1185
    filled-new-array {p1, p2}, [Ljava/lang/String;

    move-result-object v4

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    move-object v2, p0

    invoke-virtual/range {v2 .. v7}, Lcom/android/browser/provider/BrowserProvider2;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p0

    .line 1189
    :try_start_0
    invoke-interface {p0}, Landroid/database/Cursor;->moveToFirst()Z

    move-result p1

    if-eqz p1, :cond_1

    const/4 p1, 0x0

    .line 1190
    invoke-interface {p0, p1}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object p2

    const/4 v0, 0x1

    .line 1191
    invoke-interface {p0, v0}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x2

    new-array v2, v2, [Ljava/lang/String;

    aput-object p2, v2, p1

    aput-object v1, v2, v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1196
    invoke-interface {p0}, Landroid/database/Cursor;->close()V

    return-object v2

    :cond_1
    invoke-interface {p0}, Landroid/database/Cursor;->close()V

    return-object v1

    :catchall_0
    move-exception p1

    invoke-interface {p0}, Landroid/database/Cursor;->close()V

    .line 1197
    throw p1
.end method

.method private insertSearchesInTransaction(Landroid/database/sqlite/SQLiteDatabase;Landroid/content/ContentValues;)J
    .locals 12

    const-string p0, "search"

    .line 1251
    invoke-virtual {p2, p0}, Landroid/content/ContentValues;->getAsString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 1252
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_4

    const/4 v1, 0x0

    :try_start_0
    const-string v3, "searches"

    const-string v2, "_id"

    .line 1257
    filled-new-array {v2}, [Ljava/lang/String;

    move-result-object v4

    const-string v5, "search=?"

    const/4 v10, 0x1

    new-array v6, v10, [Ljava/lang/String;

    const/4 v11, 0x0

    aput-object v0, v6, v11

    const/4 v7, 0x0

    const/4 v8, 0x0

    const/4 v9, 0x0

    move-object v2, p1

    invoke-virtual/range {v2 .. v9}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v1

    .line 1259
    invoke-interface {v1}, Landroid/database/Cursor;->moveToNext()Z

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const-string v2, "searches"

    if-eqz v0, :cond_1

    .line 1260
    :try_start_1
    invoke-interface {v1, v11}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v3

    const-string p0, "_id=?"

    new-array v0, v10, [Ljava/lang/String;

    .line 1262
    invoke-static {v3, v4}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v5

    aput-object v5, v0, v11

    .line 1261
    invoke-virtual {p1, v2, p2, p0, v0}, Landroid/database/sqlite/SQLiteDatabase;->update(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    if-eqz v1, :cond_0

    .line 1268
    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    :cond_0
    return-wide v3

    .line 1265
    :cond_1
    :try_start_2
    invoke-virtual {p1, v2, p0, p2}, Landroid/database/sqlite/SQLiteDatabase;->insertOrThrow(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;)J

    move-result-wide p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    if-eqz v1, :cond_2

    .line 1268
    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    :cond_2
    return-wide p0

    :catchall_0
    move-exception p0

    if-eqz v1, :cond_3

    invoke-interface {v1}, Landroid/database/Cursor;->close()V

    .line 1269
    :cond_3
    throw p0

    .line 1253
    :cond_4
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Must include the SEARCH field"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private insertSettingsInTransaction(Landroid/database/sqlite/SQLiteDatabase;Landroid/content/ContentValues;)J
    .locals 11

    const-string p0, "key"

    .line 1276
    invoke-virtual {p2, p0}, Landroid/content/ContentValues;->getAsString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 1277
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_4

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/String;

    const/4 v10, 0x0

    aput-object v0, v1, v10

    const/4 v0, 0x0

    :try_start_0
    const-string v3, "settings"

    .line 1283
    filled-new-array {p0}, [Ljava/lang/String;

    move-result-object v4

    const-string v5, "key=?"

    const/4 v7, 0x0

    const/4 v8, 0x0

    const/4 v9, 0x0

    move-object v2, p1

    move-object v6, v1

    invoke-virtual/range {v2 .. v9}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v0

    .line 1285
    invoke-interface {v0}, Landroid/database/Cursor;->moveToNext()Z

    move-result p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const-string v2, "settings"

    if-eqz p0, :cond_1

    .line 1286
    :try_start_1
    invoke-interface {v0, v10}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v3

    const-string p0, "key=?"

    .line 1287
    invoke-virtual {p1, v2, p2, p0, v1}, Landroid/database/sqlite/SQLiteDatabase;->update(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    if-eqz v0, :cond_0

    .line 1293
    invoke-interface {v0}, Landroid/database/Cursor;->close()V

    :cond_0
    return-wide v3

    :cond_1
    :try_start_2
    const-string p0, "value"

    .line 1290
    invoke-virtual {p1, v2, p0, p2}, Landroid/database/sqlite/SQLiteDatabase;->insertOrThrow(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;)J

    move-result-wide p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    if-eqz v0, :cond_2

    .line 1293
    invoke-interface {v0}, Landroid/database/Cursor;->close()V

    :cond_2
    return-wide p0

    :catchall_0
    move-exception p0

    if-eqz v0, :cond_3

    invoke-interface {v0}, Landroid/database/Cursor;->close()V

    .line 1294
    :cond_3
    throw p0

    .line 1278
    :cond_4
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Must include the KEY field"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0
.end method

.method private isValidParent(Ljava/lang/String;Ljava/lang/String;J)Z
    .locals 0

    .line 1212
    invoke-direct {p0, p3, p4}, Lcom/android/browser/provider/BrowserProvider2;->getAccountNameAndType(J)[Ljava/lang/String;

    move-result-object p0

    const/4 p3, 0x0

    if-eqz p0, :cond_0

    .line 1213
    aget-object p4, p0, p3

    .line 1214
    invoke-static {p2, p4}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result p2

    if-eqz p2, :cond_0

    const/4 p2, 0x1

    aget-object p0, p0, p2

    .line 1215
    invoke-static {p1, p0}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result p0

    if-eqz p0, :cond_0

    return p2

    :cond_0
    return p3
.end method

.method static final qualifyColumn(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 367
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "."

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " AS "

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private setParentValues(JLandroid/content/ContentValues;)Z
    .locals 0

    .line 1201
    invoke-direct {p0, p1, p2}, Lcom/android/browser/provider/BrowserProvider2;->getAccountNameAndType(J)[Ljava/lang/String;

    move-result-object p0

    const/4 p1, 0x0

    if-nez p0, :cond_0

    return p1

    .line 1205
    :cond_0
    aget-object p1, p0, p1

    const-string p2, "account_name"

    invoke-virtual {p3, p2, p1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    const/4 p1, 0x1

    .line 1206
    aget-object p0, p0, p1

    const-string p2, "account_type"

    invoke-virtual {p3, p2, p0}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    return p1
.end method

.method private shouldUpdateImages(Landroid/database/sqlite/SQLiteDatabase;Ljava/lang/String;Landroid/content/ContentValues;)Z
    .locals 12

    const-string p0, "favicon"

    const-string v0, "thumbnail"

    const-string v1, "touch_icon"

    .line 1417
    filled-new-array {p0, v0, v1}, [Ljava/lang/String;

    move-result-object v4

    const/4 v10, 0x1

    new-array v6, v10, [Ljava/lang/String;

    const/4 v11, 0x0

    aput-object p2, v6, v11

    const-string v3, "images"

    const-string v5, "url_key=?"

    const/4 v7, 0x0

    const/4 v8, 0x0

    const/4 v9, 0x0

    move-object v2, p1

    .line 1422
    invoke-virtual/range {v2 .. v9}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p1

    .line 1424
    invoke-virtual {p3, p0}, Landroid/content/ContentValues;->getAsByteArray(Ljava/lang/String;)[B

    move-result-object p0

    .line 1425
    invoke-virtual {p3, v0}, Landroid/content/ContentValues;->getAsByteArray(Ljava/lang/String;)[B

    move-result-object p2

    .line 1426
    invoke-virtual {p3, v1}, Landroid/content/ContentValues;->getAsByteArray(Ljava/lang/String;)[B

    move-result-object p3

    .line 1431
    :try_start_0
    invoke-interface {p1}, Landroid/database/Cursor;->getCount()I

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-gtz v0, :cond_2

    if-nez p0, :cond_1

    if-nez p2, :cond_1

    if-eqz p3, :cond_0

    goto :goto_0

    :cond_0
    move v10, v11

    .line 1455
    :cond_1
    :goto_0
    invoke-interface {p1}, Landroid/database/Cursor;->close()V

    return v10

    .line 1434
    :cond_2
    :try_start_1
    invoke-interface {p1}, Landroid/database/Cursor;->moveToNext()Z

    move-result v0

    if-eqz v0, :cond_5

    if-eqz p0, :cond_3

    .line 1436
    invoke-interface {p1, v11}, Landroid/database/Cursor;->getBlob(I)[B

    move-result-object v0

    .line 1437
    invoke-static {p0, v0}, Ljava/util/Arrays;->equals([B[B)Z

    move-result v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    if-nez v0, :cond_3

    .line 1455
    invoke-interface {p1}, Landroid/database/Cursor;->close()V

    return v10

    :cond_3
    if-eqz p2, :cond_4

    .line 1442
    :try_start_2
    invoke-interface {p1, v10}, Landroid/database/Cursor;->getBlob(I)[B

    move-result-object v0

    .line 1443
    invoke-static {p2, v0}, Ljava/util/Arrays;->equals([B[B)Z

    move-result v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    if-nez v0, :cond_4

    .line 1455
    invoke-interface {p1}, Landroid/database/Cursor;->close()V

    return v10

    :cond_4
    if-eqz p3, :cond_2

    const/4 v0, 0x2

    .line 1448
    :try_start_3
    invoke-interface {p1, v0}, Landroid/database/Cursor;->getBlob(I)[B

    move-result-object v0

    .line 1449
    invoke-static {p3, v0}, Ljava/util/Arrays;->equals([B[B)Z

    move-result v0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    if-nez v0, :cond_2

    .line 1455
    invoke-interface {p1}, Landroid/database/Cursor;->close()V

    return v10

    :cond_5
    invoke-interface {p1}, Landroid/database/Cursor;->close()V

    return v11

    :catchall_0
    move-exception p0

    invoke-interface {p1}, Landroid/database/Cursor;->close()V

    .line 1456
    throw p0
.end method


# virtual methods
.method deleteBookmarks(Ljava/lang/String;[Ljava/lang/String;Z)I
    .locals 4

    .line 862
    iget-object v0, p0, Lcom/android/browser/provider/BrowserProvider2;->mOpenHelper:Lcom/android/browser/provider/BrowserProvider2$DatabaseHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    if-eqz p3, :cond_0

    const-string p0, "bookmarks"

    .line 864
    invoke-virtual {v0, p0, p1, p2}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    move-result p0

    return p0

    .line 867
    :cond_0
    invoke-direct {p0, p1, p2}, Lcom/android/browser/provider/BrowserProvider2;->appendBookmarksIfFolder(Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/Object;

    move-result-object p1

    const/4 p2, 0x0

    .line 868
    aget-object p2, p1, p2

    check-cast p2, Ljava/lang/String;

    const/4 v0, 0x1

    .line 869
    aget-object p1, p1, v0

    check-cast p1, [Ljava/lang/String;

    .line 871
    new-instance v1, Landroid/content/ContentValues;

    invoke-direct {v1}, Landroid/content/ContentValues;-><init>()V

    .line 872
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    const-string v3, "modified"

    invoke-virtual {v1, v3, v2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    .line 873
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    const-string v2, "deleted"

    invoke-virtual {v1, v2, v0}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 874
    invoke-virtual {p0, v1, p2, p1, p3}, Lcom/android/browser/provider/BrowserProvider2;->updateBookmarksInTransaction(Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;Z)I

    move-result p0

    return p0
.end method

.method public deleteInTransaction(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;Z)I
    .locals 16

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    move-object/from16 v2, p2

    move-object/from16 v3, p3

    move/from16 v4, p4

    .line 927
    sget-object v5, Lcom/android/browser/provider/BrowserProvider2;->URI_MATCHER:Landroid/content/UriMatcher;

    invoke-virtual {v5, v1}, Landroid/content/UriMatcher;->match(Landroid/net/Uri;)I

    move-result v5

    .line 928
    iget-object v6, v0, Lcom/android/browser/provider/BrowserProvider2;->mOpenHelper:Lcom/android/browser/provider/BrowserProvider2$DatabaseHelper;

    invoke-virtual {v6}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v6

    const/16 v7, 0xa

    if-eq v5, v7, :cond_d

    const/16 v7, 0xb

    const/4 v15, 0x1

    const/4 v14, 0x0

    if-eq v5, v7, :cond_c

    const/16 v7, 0x3e8

    if-eq v5, v7, :cond_b

    const/16 v7, 0x3e9

    if-eq v5, v7, :cond_a

    const/16 v7, 0x7d0

    const-string v13, "history"

    if-eq v5, v7, :cond_9

    const/16 v7, 0x7d1

    if-eq v5, v7, :cond_8

    const/16 v7, 0xbb8

    if-eq v5, v7, :cond_7

    const/16 v7, 0xbb9

    if-eq v5, v7, :cond_6

    const/16 v7, 0x2328

    if-eq v5, v7, :cond_1

    const/16 v7, 0x2329

    if-ne v5, v7, :cond_0

    const-string v5, "_id = CAST(? AS INTEGER)"

    .line 973
    invoke-static {v2, v5}, Landroid/database/DatabaseUtils;->concatenateWhere(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    new-array v5, v15, [Ljava/lang/String;

    .line 976
    invoke-static/range {p1 .. p1}, Landroid/content/ContentUris;->parseId(Landroid/net/Uri;)J

    move-result-wide v7

    invoke-static {v7, v8}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v7

    aput-object v7, v5, v14

    .line 975
    invoke-static {v3, v5}, Landroid/database/DatabaseUtils;->appendSelectionArgs([Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v3

    goto :goto_0

    .line 1023
    :cond_0
    new-instance v0, Ljava/lang/UnsupportedOperationException;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Unknown delete URI "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/UnsupportedOperationException;-><init>(Ljava/lang/String;)V

    throw v0

    :cond_1
    :goto_0
    move-object v10, v2

    const-string v2, "_id"

    const-string v5, "bookmark"

    const-string v7, "url"

    .line 980
    filled-new-array {v2, v5, v7}, [Ljava/lang/String;

    move-result-object v9

    .line 982
    new-instance v7, Landroid/database/sqlite/SQLiteQueryBuilder;

    invoke-direct {v7}, Landroid/database/sqlite/SQLiteQueryBuilder;-><init>()V

    .line 983
    invoke-direct {v0, v1, v9, v7}, Lcom/android/browser/provider/BrowserProvider2;->createCombinedQuery(Landroid/net/Uri;[Ljava/lang/String;Landroid/database/sqlite/SQLiteQueryBuilder;)[Ljava/lang/String;

    move-result-object v2

    if-nez v3, :cond_2

    goto :goto_1

    .line 987
    :cond_2
    invoke-static {v2, v3}, Landroid/database/DatabaseUtils;->appendSelectionArgs([Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v2

    :goto_1
    move-object v11, v2

    const/4 v12, 0x0

    const/4 v2, 0x0

    const/4 v3, 0x0

    move-object v8, v6

    move-object v5, v13

    move-object v13, v2

    move v2, v14

    move-object v14, v3

    .line 990
    invoke-virtual/range {v7 .. v14}, Landroid/database/sqlite/SQLiteQueryBuilder;->query(Landroid/database/sqlite/SQLiteDatabase;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v3

    move v14, v2

    .line 992
    :goto_2
    invoke-interface {v3}, Landroid/database/Cursor;->moveToNext()Z

    move-result v7

    if-eqz v7, :cond_5

    .line 993
    invoke-interface {v3, v2}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v7

    .line 994
    invoke-interface {v3, v15}, Landroid/database/Cursor;->getInt(I)I

    move-result v9

    if-eqz v9, :cond_3

    move v9, v15

    goto :goto_3

    :cond_3
    move v9, v2

    :goto_3
    const/4 v10, 0x2

    .line 995
    invoke-interface {v3, v10}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v10

    const-string v11, "_id=?"

    if-eqz v9, :cond_4

    new-array v9, v15, [Ljava/lang/String;

    .line 998
    invoke-static {v7, v8}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v7

    aput-object v7, v9, v2

    .line 997
    invoke-virtual {v0, v11, v9, v4}, Lcom/android/browser/provider/BrowserProvider2;->deleteBookmarks(Ljava/lang/String;[Ljava/lang/String;Z)I

    move-result v7

    add-int/2addr v14, v7

    new-array v7, v15, [Ljava/lang/String;

    aput-object v10, v7, v2

    const-string v8, "url=?"

    .line 1000
    invoke-virtual {v6, v5, v8, v7}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    goto :goto_2

    :cond_4
    new-array v9, v15, [Ljava/lang/String;

    .line 1005
    invoke-static {v7, v8}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v7

    aput-object v7, v9, v2

    .line 1003
    invoke-virtual {v6, v5, v11, v9}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    move-result v7

    add-int/2addr v14, v7

    goto :goto_2

    .line 1008
    :cond_5
    invoke-interface {v3}, Landroid/database/Cursor;->close()V

    goto/16 :goto_6

    :cond_6
    move v7, v14

    const-string v4, "searches._id=?"

    .line 962
    invoke-static {v2, v4}, Landroid/database/DatabaseUtils;->concatenateWhere(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    new-array v4, v15, [Ljava/lang/String;

    .line 964
    invoke-static/range {p1 .. p1}, Landroid/content/ContentUris;->parseId(Landroid/net/Uri;)J

    move-result-wide v8

    invoke-static {v8, v9}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v5

    aput-object v5, v4, v7

    .line 963
    invoke-static {v3, v4}, Landroid/database/DatabaseUtils;->appendSelectionArgs([Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v3

    :cond_7
    const-string v4, "searches"

    .line 968
    invoke-virtual {v6, v4, v2, v3}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    move-result v14

    goto/16 :goto_6

    :cond_8
    move-object v5, v13

    move v7, v14

    const-string v4, "history._id=?"

    .line 949
    invoke-static {v2, v4}, Landroid/database/DatabaseUtils;->concatenateWhere(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    new-array v4, v15, [Ljava/lang/String;

    .line 951
    invoke-static/range {p1 .. p1}, Landroid/content/ContentUris;->parseId(Landroid/net/Uri;)J

    move-result-wide v8

    invoke-static {v8, v9}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v8

    aput-object v8, v4, v7

    .line 950
    invoke-static {v3, v4}, Landroid/database/DatabaseUtils;->appendSelectionArgs([Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v3

    goto :goto_4

    :cond_9
    move-object v5, v13

    .line 955
    :goto_4
    invoke-direct {v0, v3}, Lcom/android/browser/provider/BrowserProvider2;->filterSearchClient([Ljava/lang/String;)V

    .line 956
    invoke-virtual {v6, v5, v2, v3}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    move-result v14

    .line 957
    invoke-virtual/range {p0 .. p0}, Lcom/android/browser/provider/BrowserProvider2;->pruneImages()I

    goto :goto_6

    :cond_a
    move v7, v14

    const-string v5, "bookmarks._id=?"

    .line 932
    invoke-static {v2, v5}, Landroid/database/DatabaseUtils;->concatenateWhere(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    new-array v5, v15, [Ljava/lang/String;

    .line 935
    invoke-static/range {p1 .. p1}, Landroid/content/ContentUris;->parseId(Landroid/net/Uri;)J

    move-result-wide v8

    invoke-static {v8, v9}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v6

    aput-object v6, v5, v7

    .line 934
    invoke-static {v3, v5}, Landroid/database/DatabaseUtils;->appendSelectionArgs([Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v3

    goto :goto_5

    :cond_b
    move v7, v14

    .line 940
    :goto_5
    invoke-virtual {v0, v1, v2, v3}, Lcom/android/browser/provider/BrowserProvider2;->getSelectionWithAccounts(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/Object;

    move-result-object v2

    .line 941
    aget-object v3, v2, v7

    check-cast v3, Ljava/lang/String;

    .line 942
    aget-object v2, v2, v15

    check-cast v2, [Ljava/lang/String;

    .line 943
    invoke-virtual {v0, v3, v2, v4}, Lcom/android/browser/provider/BrowserProvider2;->deleteBookmarks(Ljava/lang/String;[Ljava/lang/String;Z)I

    move-result v14

    .line 944
    invoke-virtual/range {p0 .. p0}, Lcom/android/browser/provider/BrowserProvider2;->pruneImages()I

    goto :goto_6

    :cond_c
    move v7, v14

    const-string v4, "_id = ?"

    .line 1012
    invoke-static {v2, v4}, Landroid/database/DatabaseUtils;->concatenateWhere(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    new-array v4, v15, [Ljava/lang/String;

    .line 1015
    invoke-static/range {p1 .. p1}, Landroid/content/ContentUris;->parseId(Landroid/net/Uri;)J

    move-result-wide v8

    invoke-static {v8, v9}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v5

    aput-object v5, v4, v7

    .line 1014
    invoke-static {v3, v4}, Landroid/database/DatabaseUtils;->appendSelectionArgs([Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v3

    :cond_d
    const-string v4, "thumbnails"

    .line 1019
    invoke-virtual {v6, v4, v2, v3}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    move-result v14

    :goto_6
    if-lez v14, :cond_e

    .line 1027
    invoke-virtual/range {p0 .. p1}, Lcom/android/browser/provider/SQLiteContentProvider;->postNotifyUri(Landroid/net/Uri;)V

    .line 1028
    invoke-virtual/range {p0 .. p1}, Lcom/android/browser/provider/BrowserProvider2;->shouldNotifyLegacy(Landroid/net/Uri;)Z

    move-result v1

    if-eqz v1, :cond_e

    .line 1029
    sget-object v1, Lcom/android/browser/provider/BrowserProvider2;->LEGACY_AUTHORITY_URI:Landroid/net/Uri;

    invoke-virtual {v0, v1}, Lcom/android/browser/provider/SQLiteContentProvider;->postNotifyUri(Landroid/net/Uri;)V

    :cond_e
    return v14
.end method

.method extractImageValues(Landroid/content/ContentValues;Ljava/lang/String;)Landroid/content/ContentValues;
    .locals 2

    const-string p0, "favicon"

    .line 1688
    invoke-virtual {p1, p0}, Landroid/content/ContentValues;->containsKey(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 1689
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 1690
    invoke-virtual {p1, p0}, Landroid/content/ContentValues;->getAsByteArray(Ljava/lang/String;)[B

    move-result-object v1

    invoke-virtual {v0, p0, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;[B)V

    .line 1691
    invoke-virtual {p1, p0}, Landroid/content/ContentValues;->remove(Ljava/lang/String;)V

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    const-string p0, "thumbnail"

    .line 1695
    invoke-virtual {p1, p0}, Landroid/content/ContentValues;->containsKey(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_2

    if-nez v0, :cond_1

    .line 1697
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 1699
    :cond_1
    invoke-virtual {p1, p0}, Landroid/content/ContentValues;->getAsByteArray(Ljava/lang/String;)[B

    move-result-object v1

    invoke-virtual {v0, p0, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;[B)V

    .line 1700
    invoke-virtual {p1, p0}, Landroid/content/ContentValues;->remove(Ljava/lang/String;)V

    :cond_2
    const-string p0, "touch_icon"

    .line 1704
    invoke-virtual {p1, p0}, Landroid/content/ContentValues;->containsKey(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_4

    if-nez v0, :cond_3

    .line 1706
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0}, Landroid/content/ContentValues;-><init>()V

    .line 1708
    :cond_3
    invoke-virtual {p1, p0}, Landroid/content/ContentValues;->getAsByteArray(Ljava/lang/String;)[B

    move-result-object v1

    invoke-virtual {v0, p0, v1}, Landroid/content/ContentValues;->put(Ljava/lang/String;[B)V

    .line 1709
    invoke-virtual {p1, p0}, Landroid/content/ContentValues;->remove(Ljava/lang/String;)V

    :cond_4
    if-eqz v0, :cond_5

    const-string p0, "url_key"

    .line 1713
    invoke-virtual {v0, p0, p2}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    :cond_5
    return-object v0
.end method

.method public getDatabaseHelper(Landroid/content/Context;)Landroid/database/sqlite/SQLiteOpenHelper;
    .locals 1

    .line 478
    monitor-enter p0

    .line 479
    :try_start_0
    iget-object v0, p0, Lcom/android/browser/provider/BrowserProvider2;->mOpenHelper:Lcom/android/browser/provider/BrowserProvider2$DatabaseHelper;

    if-nez v0, :cond_0

    .line 480
    new-instance v0, Lcom/android/browser/provider/BrowserProvider2$DatabaseHelper;

    invoke-direct {v0, p0, p1}, Lcom/android/browser/provider/BrowserProvider2$DatabaseHelper;-><init>(Lcom/android/browser/provider/BrowserProvider2;Landroid/content/Context;)V

    iput-object v0, p0, Lcom/android/browser/provider/BrowserProvider2;->mOpenHelper:Lcom/android/browser/provider/BrowserProvider2$DatabaseHelper;

    .line 482
    :cond_0
    iget-object p1, p0, Lcom/android/browser/provider/BrowserProvider2;->mOpenHelper:Lcom/android/browser/provider/BrowserProvider2$DatabaseHelper;

    monitor-exit p0

    return-object p1

    :catchall_0
    move-exception p1

    .line 483
    monitor-exit p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p1
.end method

.method getSelectionWithAccounts(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/Object;
    .locals 5

    const-string v0, "acct_type"

    .line 521
    invoke-virtual {p1, v0}, Landroid/net/Uri;->getQueryParameter(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "acct_name"

    .line 522
    invoke-virtual {p1, v1}, Landroid/net/Uri;->getQueryParameter(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    const/4 v1, 0x2

    const/4 v2, 0x1

    const/4 v3, 0x0

    if-eqz v0, :cond_1

    if-eqz p1, :cond_1

    .line 525
    invoke-virtual {p0, v0}, Lcom/android/browser/provider/BrowserProvider2;->isNullAccount(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_0

    invoke-virtual {p0, p1}, Lcom/android/browser/provider/BrowserProvider2;->isNullAccount(Ljava/lang/String;)Z

    move-result p0

    if-nez p0, :cond_0

    const-string p0, "account_type=? AND account_name=? "

    .line 526
    invoke-static {p2, p0}, Landroid/database/DatabaseUtils;->concatenateWhere(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    new-array p0, v1, [Ljava/lang/String;

    aput-object v0, p0, v3

    aput-object p1, p0, v2

    .line 528
    invoke-static {p3, p0}, Landroid/database/DatabaseUtils;->appendSelectionArgs([Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p3

    move p0, v2

    goto :goto_0

    :cond_0
    const-string p0, "account_name IS NULL AND account_type IS NULL"

    .line 532
    invoke-static {p2, p0}, Landroid/database/DatabaseUtils;->concatenateWhere(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    :cond_1
    move p0, v3

    :goto_0
    const/4 p1, 0x3

    new-array p1, p1, [Ljava/lang/Object;

    aput-object p2, p1, v3

    aput-object p3, p1, v2

    .line 537
    invoke-static {p0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p0

    aput-object p0, p1, v1

    return-object p1
.end method

.method public getType(Landroid/net/Uri;)Ljava/lang/String;
    .locals 0

    .line 493
    sget-object p0, Lcom/android/browser/provider/BrowserProvider2;->URI_MATCHER:Landroid/content/UriMatcher;

    invoke-virtual {p0, p1}, Landroid/content/UriMatcher;->match(Landroid/net/Uri;)I

    move-result p0

    const/16 p1, 0x3e8

    if-eq p0, p1, :cond_5

    const/16 p1, 0x3e9

    if-eq p0, p1, :cond_4

    const/16 p1, 0x7d0

    if-eq p0, p1, :cond_3

    const/16 p1, 0x7d1

    if-eq p0, p1, :cond_2

    const/16 p1, 0xbb8

    if-eq p0, p1, :cond_1

    const/16 p1, 0xbb9

    if-eq p0, p1, :cond_0

    const/16 p1, 0x2328

    if-eq p0, p1, :cond_5

    const/16 p1, 0x2329

    if-eq p0, p1, :cond_4

    const/4 p0, 0x0

    return-object p0

    :cond_0
    const-string p0, "vnd.android.cursor.item/searches"

    return-object p0

    :cond_1
    const-string p0, "vnd.android.cursor.dir/searches"

    return-object p0

    :cond_2
    const-string p0, "vnd.android.cursor.item/browser-history"

    return-object p0

    :cond_3
    const-string p0, "vnd.android.cursor.dir/browser-history"

    return-object p0

    :cond_4
    const-string p0, "vnd.android.cursor.item/bookmark"

    return-object p0

    :cond_5
    const-string p0, "vnd.android.cursor.dir/bookmark"

    return-object p0
.end method

.method getUrlCount(Landroid/database/sqlite/SQLiteDatabase;Ljava/lang/String;Ljava/lang/String;)I
    .locals 8

    const-string p0, "COUNT(*)"

    .line 1461
    filled-new-array {p0}, [Ljava/lang/String;

    move-result-object v2

    const/4 p0, 0x1

    new-array v4, p0, [Ljava/lang/String;

    const/4 p0, 0x0

    aput-object p3, v4, p0

    const-string v3, "url = ?"

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    move-object v0, p1

    move-object v1, p2

    invoke-virtual/range {v0 .. v7}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p1

    .line 1465
    :try_start_0
    invoke-interface {p1}, Landroid/database/Cursor;->moveToFirst()Z

    move-result p2

    if-eqz p2, :cond_0

    .line 1466
    invoke-interface {p1, p0}, Landroid/database/Cursor;->getInt(I)I

    move-result p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1470
    :cond_0
    invoke-interface {p1}, Landroid/database/Cursor;->close()V

    return p0

    :catchall_0
    move-exception p0

    invoke-interface {p1}, Landroid/database/Cursor;->close()V

    .line 1471
    throw p0
.end method

.method public insertInTransaction(Landroid/net/Uri;Landroid/content/ContentValues;Z)Landroid/net/Uri;
    .locals 18

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    move-object/from16 v2, p2

    .line 1056
    sget-object v3, Lcom/android/browser/provider/BrowserProvider2;->URI_MATCHER:Landroid/content/UriMatcher;

    invoke-virtual {v3, v1}, Landroid/content/UriMatcher;->match(Landroid/net/Uri;)I

    move-result v3

    .line 1057
    iget-object v4, v0, Lcom/android/browser/provider/BrowserProvider2;->mOpenHelper:Lcom/android/browser/provider/BrowserProvider2$DatabaseHelper;

    invoke-virtual {v4}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v4

    const-string v5, "folder"

    const-string v6, "visits"

    const/16 v7, 0x7d0

    const/16 v8, 0x3e8

    const/4 v9, 0x0

    const/16 v10, 0x2328

    if-ne v3, v10, :cond_2

    const-string v3, "bookmark"

    .line 1061
    invoke-virtual {v2, v3}, Landroid/content/ContentValues;->getAsInteger(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v10

    .line 1062
    invoke-virtual {v2, v3}, Landroid/content/ContentValues;->remove(Ljava/lang/String;)V

    if-eqz v10, :cond_1

    .line 1063
    invoke-virtual {v10}, Ljava/lang/Integer;->intValue()I

    move-result v3

    if-nez v3, :cond_0

    goto :goto_0

    :cond_0
    const-string v3, "date"

    .line 1067
    invoke-virtual {v2, v3}, Landroid/content/ContentValues;->remove(Ljava/lang/String;)V

    .line 1068
    invoke-virtual {v2, v6}, Landroid/content/ContentValues;->remove(Ljava/lang/String;)V

    const-string v3, "user_entered"

    .line 1069
    invoke-virtual {v2, v3}, Landroid/content/ContentValues;->remove(Ljava/lang/String;)V

    .line 1070
    invoke-static {v9}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-virtual {v2, v5, v3}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    move v3, v8

    goto :goto_1

    :cond_1
    :goto_0
    move v3, v7

    :cond_2
    :goto_1
    const/16 v10, 0xa

    if-eq v3, v10, :cond_12

    const-string v10, "favicon"

    const-string v14, "images"

    const-string v15, "created"

    const-string v11, "url"

    if-eq v3, v8, :cond_8

    if-eq v3, v7, :cond_5

    const/16 v5, 0xbb8

    if-eq v3, v5, :cond_4

    const/16 v5, 0x1f40

    if-ne v3, v5, :cond_3

    .line 1155
    invoke-direct {v0, v4, v2}, Lcom/android/browser/provider/BrowserProvider2;->insertSettingsInTransaction(Landroid/database/sqlite/SQLiteDatabase;Landroid/content/ContentValues;)J

    const-wide/16 v2, 0x0

    goto/16 :goto_6

    .line 1165
    :cond_3
    new-instance v0, Ljava/lang/UnsupportedOperationException;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Unknown insert URI "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/UnsupportedOperationException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 1149
    :cond_4
    invoke-direct {v0, v4, v2}, Lcom/android/browser/provider/BrowserProvider2;->insertSearchesInTransaction(Landroid/database/sqlite/SQLiteDatabase;Landroid/content/ContentValues;)J

    move-result-wide v2

    goto/16 :goto_6

    .line 1130
    :cond_5
    invoke-virtual {v2, v15}, Landroid/content/ContentValues;->containsKey(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_6

    .line 1131
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v7

    invoke-static {v7, v8}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v3

    invoke-virtual {v2, v15, v3}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    .line 1133
    :cond_6
    invoke-virtual {v2, v11}, Landroid/content/ContentValues;->getAsString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 1134
    invoke-direct {v0, v3}, Lcom/android/browser/provider/BrowserProvider2;->filterSearchClient(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 1135
    invoke-virtual {v2, v11, v3}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 1139
    invoke-virtual {v2, v11}, Landroid/content/ContentValues;->getAsString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 1138
    invoke-virtual {v0, v2, v3}, Lcom/android/browser/provider/BrowserProvider2;->extractImageValues(Landroid/content/ContentValues;Ljava/lang/String;)Landroid/content/ContentValues;

    move-result-object v3

    if-eqz v3, :cond_7

    .line 1141
    invoke-virtual {v4, v14, v10, v3}, Landroid/database/sqlite/SQLiteDatabase;->insertOrThrow(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;)J

    :cond_7
    const-string v3, "history"

    .line 1144
    invoke-virtual {v4, v3, v6, v2}, Landroid/database/sqlite/SQLiteDatabase;->insertOrThrow(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;)J

    move-result-wide v2

    goto/16 :goto_6

    :cond_8
    const-string v3, "dirty"

    const/4 v6, 0x1

    if-nez p3, :cond_d

    .line 1077
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v7

    .line 1078
    invoke-static {v7, v8}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v12

    invoke-virtual {v2, v15, v12}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    .line 1079
    invoke-static {v7, v8}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v7

    const-string v8, "modified"

    invoke-virtual {v2, v8, v7}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    .line 1080
    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    invoke-virtual {v2, v3, v7}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    const-string v7, "account_type"

    .line 1082
    invoke-virtual {v2, v7}, Landroid/content/ContentValues;->containsKey(Ljava/lang/String;)Z

    move-result v8

    const-string v12, "account_name"

    if-nez v8, :cond_a

    .line 1083
    invoke-virtual {v2, v12}, Landroid/content/ContentValues;->containsKey(Ljava/lang/String;)Z

    move-result v8

    if-eqz v8, :cond_9

    goto :goto_2

    :cond_9
    move v8, v9

    goto :goto_3

    :cond_a
    :goto_2
    move v8, v6

    .line 1085
    :goto_3
    invoke-virtual {v2, v7}, Landroid/content/ContentValues;->getAsString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    .line 1087
    invoke-virtual {v2, v12}, Landroid/content/ContentValues;->getAsString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v12

    const-string v15, "parent"

    .line 1088
    invoke-virtual {v2, v15}, Landroid/content/ContentValues;->containsKey(Ljava/lang/String;)Z

    move-result v16

    if-eqz v16, :cond_b

    if-eqz v8, :cond_b

    .line 1091
    invoke-virtual {v2, v15}, Landroid/content/ContentValues;->getAsLong(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object v8

    move-object/from16 v17, v14

    invoke-virtual {v8}, Ljava/lang/Long;->longValue()J

    move-result-wide v13

    .line 1092
    invoke-direct {v0, v7, v12, v13, v14}, Lcom/android/browser/provider/BrowserProvider2;->isValidParent(Ljava/lang/String;Ljava/lang/String;J)Z

    move-result v16

    goto :goto_4

    :cond_b
    move-object/from16 v17, v14

    if-eqz v16, :cond_c

    if-nez v8, :cond_c

    .line 1095
    invoke-virtual {v2, v15}, Landroid/content/ContentValues;->getAsLong(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/Long;->longValue()J

    move-result-wide v13

    .line 1096
    invoke-direct {v0, v13, v14, v2}, Lcom/android/browser/provider/BrowserProvider2;->setParentValues(JLandroid/content/ContentValues;)Z

    move-result v16

    :cond_c
    :goto_4
    if-nez v16, :cond_e

    .line 1102
    invoke-virtual {v0, v12, v7}, Lcom/android/browser/provider/BrowserProvider2;->queryDefaultFolderId(Ljava/lang/String;Ljava/lang/String;)J

    move-result-wide v7

    invoke-static {v7, v8}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v7

    .line 1101
    invoke-virtual {v2, v15, v7}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    goto :goto_5

    :cond_d
    move-object/from16 v17, v14

    :cond_e
    :goto_5
    const-string v7, "position"

    .line 1107
    invoke-virtual {v2, v7}, Landroid/content/ContentValues;->containsKey(Ljava/lang/String;)Z

    move-result v8

    if-nez v8, :cond_f

    const-wide/high16 v12, -0x8000000000000000L

    .line 1108
    invoke-static {v12, v13}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v2, v7, v8}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 1112
    :cond_f
    invoke-virtual {v2, v11}, Landroid/content/ContentValues;->getAsString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    .line 1113
    invoke-virtual {v0, v2, v7}, Lcom/android/browser/provider/BrowserProvider2;->extractImageValues(Landroid/content/ContentValues;Ljava/lang/String;)Landroid/content/ContentValues;

    move-result-object v8

    .line 1114
    invoke-virtual {v2, v5}, Landroid/content/ContentValues;->getAsBoolean(Ljava/lang/String;)Ljava/lang/Boolean;

    move-result-object v5

    if-eqz v5, :cond_10

    .line 1115
    invoke-virtual {v5}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v5

    if-nez v5, :cond_11

    :cond_10
    if-eqz v8, :cond_11

    .line 1116
    invoke-static {v7}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v5

    if-nez v5, :cond_11

    new-array v5, v6, [Ljava/lang/String;

    aput-object v7, v5, v9

    const-string v6, "url_key=?"

    move-object/from16 v7, v17

    .line 1117
    invoke-virtual {v4, v7, v8, v6, v5}, Landroid/database/sqlite/SQLiteDatabase;->update(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I

    move-result v5

    if-nez v5, :cond_11

    .line 1120
    invoke-virtual {v4, v7, v10, v8}, Landroid/database/sqlite/SQLiteDatabase;->insertOrThrow(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;)J

    :cond_11
    const-string v5, "bookmarks"

    .line 1124
    invoke-virtual {v4, v5, v3, v2}, Landroid/database/sqlite/SQLiteDatabase;->insertOrThrow(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;)J

    move-result-wide v2

    goto :goto_6

    :cond_12
    const-string v3, "thumbnails"

    const/4 v5, 0x0

    .line 1160
    invoke-virtual {v4, v3, v5, v2}, Landroid/database/sqlite/SQLiteDatabase;->replaceOrThrow(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;)J

    move-result-wide v2

    :goto_6
    const-wide/16 v4, 0x0

    cmp-long v4, v2, v4

    if-ltz v4, :cond_14

    .line 1170
    invoke-virtual/range {p0 .. p1}, Lcom/android/browser/provider/SQLiteContentProvider;->postNotifyUri(Landroid/net/Uri;)V

    .line 1171
    invoke-virtual/range {p0 .. p1}, Lcom/android/browser/provider/BrowserProvider2;->shouldNotifyLegacy(Landroid/net/Uri;)Z

    move-result v4

    if-eqz v4, :cond_13

    .line 1172
    sget-object v4, Lcom/android/browser/provider/BrowserProvider2;->LEGACY_AUTHORITY_URI:Landroid/net/Uri;

    invoke-virtual {v0, v4}, Lcom/android/browser/provider/SQLiteContentProvider;->postNotifyUri(Landroid/net/Uri;)V

    .line 1174
    :cond_13
    invoke-static {v1, v2, v3}, Landroid/content/ContentUris;->withAppendedId(Landroid/net/Uri;J)Landroid/net/Uri;

    move-result-object v0

    return-object v0

    :cond_14
    const/4 v0, 0x0

    return-object v0
.end method

.method public isCallerSyncAdapter(Landroid/net/Uri;)Z
    .locals 1

    const-string p0, "caller_is_syncadapter"

    const/4 v0, 0x0

    .line 488
    invoke-virtual {p1, p0, v0}, Landroid/net/Uri;->getBooleanQueryParameter(Ljava/lang/String;Z)Z

    move-result p0

    return p0
.end method

.method isNullAccount(Ljava/lang/String;)Z
    .locals 1

    const/4 p0, 0x1

    if-nez p1, :cond_0

    return p0

    .line 515
    :cond_0
    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    .line 516
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_2

    const-string v0, "null"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :cond_2
    :goto_0
    return p0
.end method

.method pruneImages()I
    .locals 3

    .line 1719
    iget-object p0, p0, Lcom/android/browser/provider/BrowserProvider2;->mOpenHelper:Lcom/android/browser/provider/BrowserProvider2$DatabaseHelper;

    invoke-virtual {p0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object p0

    const-string v0, "images"

    const-string v1, "url_key NOT IN (SELECT url FROM bookmarks WHERE url IS NOT NULL AND deleted == 0) AND url_key NOT IN (SELECT url FROM history WHERE url IS NOT NULL)"

    const/4 v2, 0x0

    .line 1720
    invoke-virtual {p0, v0, v1, v2}, Landroid/database/sqlite/SQLiteDatabase;->delete(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;)I

    move-result p0

    return p0
.end method

.method public query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;
    .locals 23

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    move-object/from16 v2, p3

    move-object/from16 v3, p4

    .line 543
    iget-object v4, v0, Lcom/android/browser/provider/BrowserProvider2;->mOpenHelper:Lcom/android/browser/provider/BrowserProvider2$DatabaseHelper;

    invoke-virtual {v4}, Landroid/database/sqlite/SQLiteOpenHelper;->getReadableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v6

    .line 544
    sget-object v4, Lcom/android/browser/provider/BrowserProvider2;->URI_MATCHER:Landroid/content/UriMatcher;

    invoke-virtual {v4, v1}, Landroid/content/UriMatcher;->match(Landroid/net/Uri;)I

    move-result v4

    .line 545
    new-instance v5, Landroid/database/sqlite/SQLiteQueryBuilder;

    invoke-direct {v5}, Landroid/database/sqlite/SQLiteQueryBuilder;-><init>()V

    const-string v7, "limit"

    .line 546
    invoke-virtual {v1, v7}, Landroid/net/Uri;->getQueryParameter(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v14

    const-string v7, "groupBy"

    .line 547
    invoke-virtual {v1, v7}, Landroid/net/Uri;->getQueryParameter(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    const/16 v7, 0xa

    if-eq v4, v7, :cond_1e

    const/16 v7, 0xb

    const/4 v15, 0x1

    const/4 v13, 0x0

    if-eq v4, v7, :cond_1d

    const/16 v7, 0x14

    if-eq v4, v7, :cond_1b

    const/16 v7, 0x1388

    if-eq v4, v7, :cond_1a

    const/16 v7, 0x1b58

    if-eq v4, v7, :cond_18

    const/16 v7, 0x1f40

    if-eq v4, v7, :cond_17

    const/16 v7, 0x7d0

    if-eq v4, v7, :cond_15

    const/16 v7, 0x7d1

    if-eq v4, v7, :cond_14

    const/16 v7, 0xbb8

    if-eq v4, v7, :cond_13

    const/16 v7, 0xbb9

    if-eq v4, v7, :cond_12

    const/16 v7, 0x1770

    const/16 v8, 0x2329

    const/16 v9, 0x2328

    if-eq v4, v7, :cond_e

    const/16 v7, 0x1771

    if-eq v4, v7, :cond_d

    if-eq v4, v9, :cond_e

    if-eq v4, v8, :cond_d

    const-string v7, "position ASC, _id ASC"

    const-string v8, "folder DESC, position ASC, _id ASC"

    const-string v9, "bookmarks LEFT OUTER JOIN images ON bookmarks.url = images.url_key"

    const-string v11, "acct_name"

    const-string v12, "acct_type"

    move-object/from16 v16, v10

    const/4 v10, 0x2

    packed-switch v4, :pswitch_data_0

    .line 774
    new-instance v0, Ljava/lang/UnsupportedOperationException;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "Unknown URL "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual/range {p1 .. p1}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/UnsupportedOperationException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 681
    :pswitch_0
    invoke-virtual {v1, v11}, Landroid/net/Uri;->getQueryParameter(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 682
    invoke-virtual {v1, v12}, Landroid/net/Uri;->getQueryParameter(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 683
    invoke-virtual {v0, v2, v1}, Lcom/android/browser/provider/BrowserProvider2;->queryDefaultFolderId(Ljava/lang/String;Ljava/lang/String;)J

    move-result-wide v0

    .line 684
    new-instance v2, Landroid/database/MatrixCursor;

    const-string v3, "_id"

    filled-new-array {v3}, [Ljava/lang/String;

    move-result-object v3

    invoke-direct {v2, v3}, Landroid/database/MatrixCursor;-><init>([Ljava/lang/String;)V

    .line 685
    invoke-virtual {v2}, Landroid/database/MatrixCursor;->newRow()Landroid/database/MatrixCursor$RowBuilder;

    move-result-object v3

    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v0

    invoke-virtual {v3, v0}, Landroid/database/MatrixCursor$RowBuilder;->add(Ljava/lang/Object;)Landroid/database/MatrixCursor$RowBuilder;

    return-object v2

    .line 690
    :pswitch_1
    invoke-direct {v0, v2, v3, v14}, Lcom/android/browser/provider/BrowserProvider2;->doSuggestQuery(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v0

    return-object v0

    .line 608
    :pswitch_2
    invoke-virtual {v1, v12}, Landroid/net/Uri;->getQueryParameter(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 609
    invoke-virtual {v1, v11}, Landroid/net/Uri;->getQueryParameter(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 610
    invoke-virtual {v0, v4}, Lcom/android/browser/provider/BrowserProvider2;->isNullAccount(Ljava/lang/String;)Z

    move-result v11

    if-nez v11, :cond_0

    invoke-virtual {v0, v1}, Lcom/android/browser/provider/BrowserProvider2;->isNullAccount(Ljava/lang/String;)Z

    move-result v11

    if-nez v11, :cond_0

    move v11, v15

    goto :goto_0

    :cond_0
    move v11, v13

    .line 614
    :goto_0
    invoke-virtual {v5, v9}, Landroid/database/sqlite/SQLiteQueryBuilder;->setTables(Ljava/lang/String;)V

    .line 618
    invoke-static/range {p5 .. p5}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v9

    if-eqz v9, :cond_2

    if-eqz v11, :cond_1

    move-object v12, v7

    goto :goto_1

    :cond_1
    move-object v12, v8

    goto :goto_1

    :cond_2
    move-object/from16 v12, p5

    :goto_1
    if-nez v11, :cond_4

    .line 626
    sget-object v1, Lcom/android/browser/provider/BrowserProvider2;->BOOKMARKS_PROJECTION_MAP:Ljava/util/HashMap;

    invoke-virtual {v5, v1}, Landroid/database/sqlite/SQLiteQueryBuilder;->setProjectionMap(Ljava/util/Map;)V

    const-string v1, "parent=? AND deleted=0"

    .line 628
    invoke-static {v1, v2}, Landroid/database/DatabaseUtils;->concatenateWhere(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    new-array v1, v15, [Ljava/lang/String;

    const-wide/16 v7, 0x1

    .line 629
    invoke-static {v7, v8}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v2

    aput-object v2, v1, v13

    if-eqz v3, :cond_3

    .line 631
    invoke-static {v1, v3}, Landroid/database/DatabaseUtils;->appendSelectionArgs([Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    :cond_3
    const/4 v10, 0x0

    const/4 v11, 0x0

    const/4 v13, 0x0

    move-object v7, v5

    move-object/from16 v8, p2

    .line 633
    invoke-virtual/range {v7 .. v13}, Landroid/database/sqlite/SQLiteQueryBuilder;->buildQuery([Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    goto/16 :goto_2

    .line 635
    :cond_4
    sget-object v7, Lcom/android/browser/provider/BrowserProvider2;->BOOKMARKS_PROJECTION_MAP:Ljava/util/HashMap;

    invoke-virtual {v5, v7}, Landroid/database/sqlite/SQLiteQueryBuilder;->setProjectionMap(Ljava/util/Map;)V

    const-string v7, "account_type=? AND account_name=? AND parent = (SELECT _id FROM bookmarks WHERE sync3=\'bookmark_bar\' AND account_type = ? AND account_name = ?) AND deleted=0"

    .line 644
    invoke-static {v7, v2}, Landroid/database/DatabaseUtils;->concatenateWhere(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    const/4 v11, 0x0

    const/16 v16, 0x0

    const/16 v17, 0x0

    const/16 v18, 0x0

    move-object v7, v5

    move-object/from16 v8, p2

    move-object v10, v11

    move-object/from16 v11, v16

    move-object/from16 v20, v12

    move-object/from16 v12, v17

    move v15, v13

    move-object/from16 v13, v18

    .line 645
    invoke-virtual/range {v7 .. v13}, Landroid/database/sqlite/SQLiteQueryBuilder;->buildQuery([Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v16

    const/4 v7, 0x4

    new-array v7, v7, [Ljava/lang/String;

    aput-object v4, v7, v15

    const/4 v8, 0x1

    aput-object v1, v7, v8

    const/4 v13, 0x2

    aput-object v4, v7, v13

    const/4 v12, 0x3

    aput-object v1, v7, v12

    if-eqz v3, :cond_5

    .line 650
    invoke-static {v7, v3}, Landroid/database/DatabaseUtils;->appendSelectionArgs([Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v7

    :cond_5
    move-object v11, v7

    const-string v7, "account_type=? AND account_name=? AND sync3=?"

    .line 655
    invoke-static {v7, v2}, Landroid/database/DatabaseUtils;->concatenateWhere(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    .line 656
    sget-object v2, Lcom/android/browser/provider/BrowserProvider2;->OTHER_BOOKMARKS_PROJECTION_MAP:Ljava/util/HashMap;

    invoke-virtual {v5, v2}, Landroid/database/sqlite/SQLiteQueryBuilder;->setProjectionMap(Ljava/util/Map;)V

    const/4 v10, 0x0

    const/4 v2, 0x0

    const/16 v18, 0x0

    const/16 v19, 0x0

    move-object v7, v5

    move-object/from16 v8, p2

    move-object/from16 v21, v11

    move-object v11, v2

    move v2, v12

    move-object/from16 v12, v18

    move v2, v13

    move-object/from16 v13, v19

    .line 657
    invoke-virtual/range {v7 .. v13}, Landroid/database/sqlite/SQLiteQueryBuilder;->buildQuery([Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    new-array v8, v2, [Ljava/lang/String;

    aput-object v16, v8, v15

    const/4 v9, 0x1

    aput-object v7, v8, v9

    move-object/from16 v7, v20

    .line 660
    invoke-virtual {v5, v8, v7, v14}, Landroid/database/sqlite/SQLiteQueryBuilder;->buildUnionQuery([Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    const/4 v7, 0x3

    new-array v7, v7, [Ljava/lang/String;

    aput-object v4, v7, v15

    aput-object v1, v7, v9

    const-string v1, "other_bookmarks"

    aput-object v1, v7, v2

    move-object/from16 v1, v21

    .line 664
    invoke-static {v1, v7}, Landroid/database/DatabaseUtils;->appendSelectionArgs([Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    if-eqz v3, :cond_6

    .line 668
    invoke-static {v1, v3}, Landroid/database/DatabaseUtils;->appendSelectionArgs([Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    :cond_6
    move-object v2, v5

    .line 672
    :goto_2
    invoke-virtual {v6, v2, v1}, Landroid/database/sqlite/SQLiteDatabase;->rawQuery(Ljava/lang/String;[Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v1

    if-eqz v1, :cond_7

    .line 674
    invoke-virtual/range {p0 .. p0}, Landroid/content/ContentProvider;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    sget-object v2, Landroid/provider/BrowserContract;->AUTHORITY_URI:Landroid/net/Uri;

    invoke-interface {v1, v0, v2}, Landroid/database/Cursor;->setNotificationUri(Landroid/content/ContentResolver;Landroid/net/Uri;)V

    :cond_7
    return-object v1

    :pswitch_3
    move v15, v13

    move/from16 v22, v10

    move-object v10, v2

    move/from16 v2, v22

    const-string v11, "show_deleted"

    .line 567
    invoke-virtual {v1, v11, v15}, Landroid/net/Uri;->getBooleanQueryParameter(Ljava/lang/String;Z)Z

    move-result v11

    if-nez v11, :cond_8

    const-string v11, "deleted=0"

    .line 568
    invoke-static {v11, v10}, Landroid/database/DatabaseUtils;->concatenateWhere(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    :cond_8
    const/16 v11, 0x3e9

    if-ne v4, v11, :cond_9

    const-string v4, "bookmarks._id=?"

    .line 574
    invoke-static {v10, v4}, Landroid/database/DatabaseUtils;->concatenateWhere(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    const/4 v11, 0x1

    new-array v4, v11, [Ljava/lang/String;

    .line 577
    invoke-static/range {p1 .. p1}, Landroid/content/ContentUris;->parseId(Landroid/net/Uri;)J

    move-result-wide v12

    invoke-static {v12, v13}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v12

    aput-object v12, v4, v15

    .line 576
    invoke-static {v3, v4}, Landroid/database/DatabaseUtils;->appendSelectionArgs([Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v3

    goto :goto_3

    :cond_9
    const/4 v11, 0x1

    const/16 v12, 0x3eb

    if-ne v4, v12, :cond_a

    const-string v4, "bookmarks.parent=?"

    .line 580
    invoke-static {v10, v4}, Landroid/database/DatabaseUtils;->concatenateWhere(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    new-array v4, v11, [Ljava/lang/String;

    .line 583
    invoke-static/range {p1 .. p1}, Landroid/content/ContentUris;->parseId(Landroid/net/Uri;)J

    move-result-wide v12

    invoke-static {v12, v13}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v12

    aput-object v12, v4, v15

    .line 582
    invoke-static {v3, v4}, Landroid/database/DatabaseUtils;->appendSelectionArgs([Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v3

    .line 586
    :cond_a
    :goto_3
    invoke-virtual {v0, v1, v10, v3}, Lcom/android/browser/provider/BrowserProvider2;->getSelectionWithAccounts(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/Object;

    move-result-object v1

    .line 587
    aget-object v3, v1, v15

    check-cast v3, Ljava/lang/String;

    .line 588
    aget-object v4, v1, v11

    check-cast v4, [Ljava/lang/String;

    .line 589
    aget-object v1, v1, v2

    check-cast v1, Ljava/lang/Boolean;

    invoke-virtual {v1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v1

    .line 592
    invoke-static/range {p5 .. p5}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_c

    if-eqz v1, :cond_b

    goto :goto_4

    :cond_b
    move-object v7, v8

    goto :goto_4

    :cond_c
    move-object/from16 v7, p5

    .line 600
    :goto_4
    sget-object v1, Lcom/android/browser/provider/BrowserProvider2;->BOOKMARKS_PROJECTION_MAP:Ljava/util/HashMap;

    invoke-virtual {v5, v1}, Landroid/database/sqlite/SQLiteQueryBuilder;->setProjectionMap(Ljava/util/Map;)V

    .line 601
    invoke-virtual {v5, v9}, Landroid/database/sqlite/SQLiteQueryBuilder;->setTables(Ljava/lang/String;)V

    move-object v8, v3

    move-object v9, v4

    move-object v12, v7

    move-object/from16 v7, p2

    goto/16 :goto_11

    :cond_d
    move-object/from16 v16, v10

    move v15, v13

    move-object v10, v2

    goto :goto_5

    :cond_e
    move-object/from16 v16, v10

    goto :goto_6

    :goto_5
    const-string v2, "_id = CAST(? AS INTEGER)"

    .line 729
    invoke-static {v10, v2}, Landroid/database/DatabaseUtils;->concatenateWhere(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    const/4 v7, 0x1

    new-array v7, v7, [Ljava/lang/String;

    .line 732
    invoke-static/range {p1 .. p1}, Landroid/content/ContentUris;->parseId(Landroid/net/Uri;)J

    move-result-wide v10

    invoke-static {v10, v11}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v10

    aput-object v10, v7, v15

    .line 731
    invoke-static {v3, v7}, Landroid/database/DatabaseUtils;->appendSelectionArgs([Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v3

    :goto_6
    move-object v10, v2

    if-eq v4, v9, :cond_f

    if-ne v4, v8, :cond_10

    :cond_f
    if-nez p2, :cond_10

    .line 739
    sget-object v2, Landroid/provider/Browser;->HISTORY_PROJECTION:[Ljava/lang/String;

    goto :goto_7

    :cond_10
    move-object/from16 v2, p2

    .line 741
    :goto_7
    invoke-direct {v0, v1, v2, v5}, Lcom/android/browser/provider/BrowserProvider2;->createCombinedQuery(Landroid/net/Uri;[Ljava/lang/String;Landroid/database/sqlite/SQLiteQueryBuilder;)[Ljava/lang/String;

    move-result-object v1

    if-nez v3, :cond_11

    goto :goto_8

    .line 745
    :cond_11
    invoke-static {v1, v3}, Landroid/database/DatabaseUtils;->appendSelectionArgs([Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    :goto_8
    move-object/from16 v12, p5

    move-object v9, v1

    move-object v7, v2

    goto/16 :goto_10

    :cond_12
    move-object/from16 v16, v10

    move v15, v13

    move-object v10, v2

    const-string v2, "searches._id=?"

    .line 710
    invoke-static {v10, v2}, Landroid/database/DatabaseUtils;->concatenateWhere(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    const/4 v4, 0x1

    new-array v4, v4, [Ljava/lang/String;

    .line 712
    invoke-static/range {p1 .. p1}, Landroid/content/ContentUris;->parseId(Landroid/net/Uri;)J

    move-result-wide v7

    invoke-static {v7, v8}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v1

    aput-object v1, v4, v15

    .line 711
    invoke-static {v3, v4}, Landroid/database/DatabaseUtils;->appendSelectionArgs([Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    move-object v10, v2

    goto :goto_9

    :cond_13
    move-object/from16 v16, v10

    move-object v10, v2

    move-object v1, v3

    :goto_9
    const-string v2, "searches"

    .line 716
    invoke-virtual {v5, v2}, Landroid/database/sqlite/SQLiteQueryBuilder;->setTables(Ljava/lang/String;)V

    .line 717
    sget-object v2, Lcom/android/browser/provider/BrowserProvider2;->SEARCHES_PROJECTION_MAP:Ljava/util/HashMap;

    invoke-virtual {v5, v2}, Landroid/database/sqlite/SQLiteQueryBuilder;->setProjectionMap(Ljava/util/Map;)V

    goto/16 :goto_f

    :cond_14
    move-object/from16 v16, v10

    move v15, v13

    move-object v10, v2

    const-string v2, "history._id=?"

    .line 694
    invoke-static {v10, v2}, Landroid/database/DatabaseUtils;->concatenateWhere(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    const/4 v4, 0x1

    new-array v4, v4, [Ljava/lang/String;

    .line 696
    invoke-static/range {p1 .. p1}, Landroid/content/ContentUris;->parseId(Landroid/net/Uri;)J

    move-result-wide v7

    invoke-static {v7, v8}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v1

    aput-object v1, v4, v15

    .line 695
    invoke-static {v3, v4}, Landroid/database/DatabaseUtils;->appendSelectionArgs([Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    move-object v10, v2

    goto :goto_a

    :cond_15
    move-object/from16 v16, v10

    move-object v10, v2

    move-object v1, v3

    .line 700
    :goto_a
    invoke-direct {v0, v1}, Lcom/android/browser/provider/BrowserProvider2;->filterSearchClient([Ljava/lang/String;)V

    if-nez p5, :cond_16

    const-string v2, "date DESC"

    goto :goto_b

    :cond_16
    move-object/from16 v2, p5

    .line 704
    :goto_b
    sget-object v3, Lcom/android/browser/provider/BrowserProvider2;->HISTORY_PROJECTION_MAP:Ljava/util/HashMap;

    invoke-virtual {v5, v3}, Landroid/database/sqlite/SQLiteQueryBuilder;->setProjectionMap(Ljava/util/Map;)V

    const-string v3, "history LEFT OUTER JOIN images ON history.url = images.url_key"

    .line 705
    invoke-virtual {v5, v3}, Landroid/database/sqlite/SQLiteQueryBuilder;->setTables(Ljava/lang/String;)V

    move-object/from16 v7, p2

    move-object v9, v1

    move-object v12, v2

    goto/16 :goto_10

    :cond_17
    move-object/from16 v16, v10

    move-object v10, v2

    const-string v1, "settings"

    .line 751
    invoke-virtual {v5, v1}, Landroid/database/sqlite/SQLiteQueryBuilder;->setTables(Ljava/lang/String;)V

    .line 752
    sget-object v1, Lcom/android/browser/provider/BrowserProvider2;->SETTINGS_PROJECTION_MAP:Ljava/util/HashMap;

    invoke-virtual {v5, v1}, Landroid/database/sqlite/SQLiteQueryBuilder;->setProjectionMap(Ljava/util/Map;)V

    goto :goto_c

    :cond_18
    move-object/from16 v16, v10

    move-object v10, v2

    const-string v2, "v_accounts"

    .line 550
    invoke-virtual {v5, v2}, Landroid/database/sqlite/SQLiteQueryBuilder;->setTables(Ljava/lang/String;)V

    .line 551
    sget-object v2, Lcom/android/browser/provider/BrowserProvider2;->ACCOUNTS_PROJECTION_MAP:Ljava/util/HashMap;

    invoke-virtual {v5, v2}, Landroid/database/sqlite/SQLiteQueryBuilder;->setProjectionMap(Ljava/util/Map;)V

    const-string v2, "allowEmptyAccounts"

    .line 552
    invoke-virtual {v1, v2}, Landroid/net/Uri;->getQueryParameter(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "false"

    .line 553
    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_19

    const-string v1, "0 < ( SELECT count(*) FROM bookmarks WHERE deleted = 0 AND folder = 0   AND (     v_accounts.account_name = bookmarks.account_name     OR (v_accounts.account_name IS NULL AND bookmarks.account_name IS NULL)   )   AND (     v_accounts.account_type = bookmarks.account_type     OR (v_accounts.account_type IS NULL AND bookmarks.account_type IS NULL)   ) )"

    .line 554
    invoke-static {v10, v1}, Landroid/database/DatabaseUtils;->concatenateWhere(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    move-object v10, v1

    :cond_19
    if-nez p5, :cond_1c

    const-string v1, "account_name IS NOT NULL DESC, account_name ASC"

    move-object/from16 v7, p2

    move-object v12, v1

    goto :goto_d

    :cond_1a
    move-object/from16 v16, v10

    move-object v10, v2

    const-string v1, "images"

    .line 722
    invoke-virtual {v5, v1}, Landroid/database/sqlite/SQLiteQueryBuilder;->setTables(Ljava/lang/String;)V

    .line 723
    sget-object v1, Lcom/android/browser/provider/BrowserProvider2;->IMAGES_PROJECTION_MAP:Ljava/util/HashMap;

    invoke-virtual {v5, v1}, Landroid/database/sqlite/SQLiteQueryBuilder;->setProjectionMap(Ljava/util/Map;)V

    goto :goto_c

    :cond_1b
    move-object/from16 v16, v10

    move-object v10, v2

    const-string v1, "v_omnibox_suggestions"

    .line 769
    invoke-virtual {v5, v1}, Landroid/database/sqlite/SQLiteQueryBuilder;->setTables(Ljava/lang/String;)V

    :cond_1c
    :goto_c
    move-object/from16 v7, p2

    move-object/from16 v12, p5

    :goto_d
    move-object v9, v3

    goto :goto_10

    :cond_1d
    move-object/from16 v16, v10

    move v15, v13

    move-object v10, v2

    const-string v2, "_id = ?"

    .line 757
    invoke-static {v10, v2}, Landroid/database/DatabaseUtils;->concatenateWhere(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    const/4 v4, 0x1

    new-array v4, v4, [Ljava/lang/String;

    .line 760
    invoke-static/range {p1 .. p1}, Landroid/content/ContentUris;->parseId(Landroid/net/Uri;)J

    move-result-wide v7

    invoke-static {v7, v8}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v1

    aput-object v1, v4, v15

    .line 759
    invoke-static {v3, v4}, Landroid/database/DatabaseUtils;->appendSelectionArgs([Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    move-object v10, v2

    goto :goto_e

    :cond_1e
    move-object/from16 v16, v10

    move-object v10, v2

    move-object v1, v3

    :goto_e
    const-string v2, "thumbnails"

    .line 764
    invoke-virtual {v5, v2}, Landroid/database/sqlite/SQLiteQueryBuilder;->setTables(Ljava/lang/String;)V

    :goto_f
    move-object/from16 v7, p2

    move-object/from16 v12, p5

    move-object v9, v1

    :goto_10
    move-object v8, v10

    :goto_11
    const/4 v11, 0x0

    move-object/from16 v10, v16

    move-object v13, v14

    .line 778
    invoke-virtual/range {v5 .. v13}, Landroid/database/sqlite/SQLiteQueryBuilder;->query(Landroid/database/sqlite/SQLiteDatabase;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v1

    .line 780
    invoke-virtual/range {p0 .. p0}, Landroid/content/ContentProvider;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    sget-object v2, Landroid/provider/BrowserContract;->AUTHORITY_URI:Landroid/net/Uri;

    invoke-interface {v1, v0, v2}, Landroid/database/Cursor;->setNotificationUri(Landroid/content/ContentResolver;Landroid/net/Uri;)V

    return-object v1

    :pswitch_data_0
    .packed-switch 0x3e8
        :pswitch_3
        :pswitch_3
        :pswitch_2
        :pswitch_3
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method queryDefaultFolderId(Ljava/lang/String;Ljava/lang/String;)J
    .locals 9

    .line 1036
    invoke-virtual {p0, p1}, Lcom/android/browser/provider/BrowserProvider2;->isNullAccount(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    invoke-virtual {p0, p2}, Lcom/android/browser/provider/BrowserProvider2;->isNullAccount(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 1037
    iget-object p0, p0, Lcom/android/browser/provider/BrowserProvider2;->mOpenHelper:Lcom/android/browser/provider/BrowserProvider2$DatabaseHelper;

    invoke-virtual {p0}, Landroid/database/sqlite/SQLiteOpenHelper;->getReadableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    const-string p0, "_id"

    .line 1038
    filled-new-array {p0}, [Ljava/lang/String;

    move-result-object v2

    const/4 p0, 0x3

    new-array v4, p0, [Ljava/lang/String;

    const-string p0, "bookmark_bar"

    const/4 v8, 0x0

    aput-object p0, v4, v8

    const/4 p0, 0x1

    aput-object p2, v4, p0

    const/4 p0, 0x2

    aput-object p1, v4, p0

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    const-string v1, "bookmarks"

    const-string v3, "sync3 = ? AND account_type = ? AND account_name = ?"

    invoke-virtual/range {v0 .. v7}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p0

    .line 1044
    :try_start_0
    invoke-interface {p0}, Landroid/database/Cursor;->moveToFirst()Z

    move-result p1

    if-eqz p1, :cond_0

    .line 1045
    invoke-interface {p0, v8}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide p1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 1048
    invoke-interface {p0}, Landroid/database/Cursor;->close()V

    return-wide p1

    :cond_0
    invoke-interface {p0}, Landroid/database/Cursor;->close()V

    goto :goto_0

    :catchall_0
    move-exception p1

    invoke-interface {p0}, Landroid/database/Cursor;->close()V

    .line 1049
    throw p1

    :cond_1
    :goto_0
    const-wide/16 p0, 0x1

    return-wide p0
.end method

.method shouldNotifyLegacy(Landroid/net/Uri;)Z
    .locals 1

    .line 1724
    invoke-virtual {p1}, Landroid/net/Uri;->getPathSegments()Ljava/util/List;

    move-result-object p0

    const-string v0, "history"

    invoke-interface {p0, v0}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_1

    .line 1725
    invoke-virtual {p1}, Landroid/net/Uri;->getPathSegments()Ljava/util/List;

    move-result-object p0

    const-string v0, "bookmarks"

    invoke-interface {p0, v0}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_1

    .line 1726
    invoke-virtual {p1}, Landroid/net/Uri;->getPathSegments()Ljava/util/List;

    move-result-object p0

    const-string p1, "searches"

    invoke-interface {p0, p1}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    return p0

    :cond_1
    :goto_0
    const/4 p0, 0x1

    return p0
.end method

.method protected syncToNetwork(Landroid/net/Uri;)Z
    .locals 0

    const/4 p0, 0x0

    return p0
.end method

.method updateBookmarksInTransaction(Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;Z)I
    .locals 25

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    move/from16 v2, p4

    const-string v3, "images"

    const-string v4, "url"

    .line 1480
    iget-object v5, v0, Lcom/android/browser/provider/BrowserProvider2;->mOpenHelper:Lcom/android/browser/provider/BrowserProvider2$DatabaseHelper;

    invoke-virtual {v5}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v5

    const-string v6, "_id"

    const-string v7, "version"

    const-string v8, "url"

    const-string v9, "title"

    const-string v10, "folder"

    const-string v11, "account_name"

    const-string v12, "account_type"

    .line 1481
    filled-new-array/range {v6 .. v12}, [Ljava/lang/String;

    move-result-object v8

    const-string v7, "bookmarks"

    const/4 v11, 0x0

    const/4 v12, 0x0

    const/4 v13, 0x0

    move-object v6, v5

    move-object/from16 v9, p2

    move-object/from16 v10, p3

    .line 1490
    invoke-virtual/range {v6 .. v13}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v14

    const-string v15, "parent"

    .line 1492
    invoke-virtual {v1, v15}, Landroid/content/ContentValues;->containsKey(Ljava/lang/String;)Z

    move-result v16

    const-string v13, "account_type"

    const-string v12, "account_name"

    const/4 v10, 0x0

    const/4 v9, 0x1

    if-eqz v16, :cond_1

    .line 1496
    invoke-virtual {v1, v15}, Landroid/content/ContentValues;->getAsLong(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/Long;->longValue()J

    move-result-wide v6

    .line 1497
    filled-new-array {v12, v13}, [Ljava/lang/String;

    move-result-object v8

    new-array v11, v9, [Ljava/lang/String;

    .line 1499
    invoke-static {v6, v7}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v6

    aput-object v6, v11, v10

    const/16 v17, 0x0

    const/16 v18, 0x0

    const/16 v19, 0x0

    const-string v7, "bookmarks"

    const-string v20, "_id = ?"

    move-object v6, v5

    move-object/from16 v9, v20

    move-object v10, v11

    move-object/from16 v11, v17

    move-object/from16 v23, v12

    move-object/from16 v12, v18

    move-object/from16 v17, v3

    move-object v3, v13

    move-object/from16 v13, v19

    .line 1497
    invoke-virtual/range {v6 .. v13}, Landroid/database/sqlite/SQLiteDatabase;->query(Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v6

    .line 1501
    invoke-interface {v6}, Landroid/database/Cursor;->moveToFirst()Z

    move-result v7

    if-eqz v7, :cond_0

    const/4 v7, 0x0

    .line 1502
    invoke-interface {v6, v7}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v11

    const/4 v8, 0x1

    .line 1503
    invoke-interface {v6, v8}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v9

    goto :goto_0

    :cond_0
    const/4 v7, 0x0

    const/4 v8, 0x1

    const/4 v9, 0x0

    const/4 v11, 0x0

    .line 1505
    :goto_0
    invoke-interface {v6}, Landroid/database/Cursor;->close()V

    move-object/from16 v6, v23

    goto :goto_1

    :cond_1
    move-object/from16 v17, v3

    move v8, v9

    move v7, v10

    move-object v6, v12

    move-object v3, v13

    .line 1506
    invoke-virtual {v1, v6}, Landroid/content/ContentValues;->containsKey(Ljava/lang/String;)Z

    move-result v9

    if-nez v9, :cond_2

    .line 1507
    invoke-virtual {v1, v3}, Landroid/content/ContentValues;->containsKey(Ljava/lang/String;)Z

    :cond_2
    const/4 v9, 0x0

    const/4 v11, 0x0

    :goto_1
    :try_start_0
    new-array v10, v8, [Ljava/lang/String;

    if-nez v2, :cond_3

    const-string v12, "modified"

    .line 1514
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v18

    invoke-static/range {v18 .. v19}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v13

    invoke-virtual {v1, v12, v13}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    const-string v12, "dirty"

    .line 1515
    invoke-static {v8}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v13

    invoke-virtual {v1, v12, v13}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Integer;)V

    .line 1518
    :cond_3
    invoke-virtual {v1, v4}, Landroid/content/ContentValues;->containsKey(Ljava/lang/String;)Z

    move-result v12

    if-eqz v12, :cond_4

    .line 1521
    invoke-virtual {v1, v4}, Landroid/content/ContentValues;->getAsString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    goto :goto_2

    :cond_4
    const/4 v4, 0x0

    .line 1523
    :goto_2
    invoke-virtual {v0, v1, v4}, Lcom/android/browser/provider/BrowserProvider2;->extractImageValues(Landroid/content/ContentValues;Ljava/lang/String;)Landroid/content/ContentValues;

    move-result-object v13

    move/from16 v18, v7

    .line 1525
    :goto_3
    invoke-interface {v14}, Landroid/database/Cursor;->moveToNext()Z

    move-result v19

    if-eqz v19, :cond_e

    move-object/from16 v19, v9

    .line 1526
    invoke-interface {v14, v7}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v8

    .line 1527
    invoke-static {v8, v9}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v20

    aput-object v20, v10, v7

    const/4 v7, 0x5

    .line 1528
    invoke-interface {v14, v7}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v7

    move-object/from16 p2, v4

    const/4 v4, 0x6

    .line 1529
    invoke-interface {v14, v4}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v4
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move/from16 p3, v12

    const-string v12, "version"

    if-eqz v16, :cond_8

    .line 1533
    :try_start_1
    invoke-static {v7, v11}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v7

    if-eqz v7, :cond_6

    move-object/from16 v7, v19

    .line 1534
    invoke-static {v4, v7}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v4

    if-nez v4, :cond_5

    goto :goto_4

    :cond_5
    move-object/from16 v20, v3

    move-object/from16 v19, v13

    const/4 v4, 0x0

    goto :goto_6

    :cond_6
    move-object/from16 v7, v19

    .line 1539
    :goto_4
    invoke-virtual {v0, v14}, Lcom/android/browser/provider/BrowserProvider2;->valuesFromCursor(Landroid/database/Cursor;)Landroid/content/ContentValues;

    move-result-object v4

    .line 1540
    invoke-virtual {v4, v1}, Landroid/content/ContentValues;->putAll(Landroid/content/ContentValues;)V

    move-object/from16 v19, v13

    const-string v13, "_id"

    .line 1541
    invoke-virtual {v4, v13}, Landroid/content/ContentValues;->remove(Ljava/lang/String;)V

    .line 1542
    invoke-virtual {v4, v12}, Landroid/content/ContentValues;->remove(Ljava/lang/String;)V

    .line 1543
    invoke-virtual {v4, v6, v11}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 1544
    invoke-virtual {v4, v3, v7}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 1545
    sget-object v12, Landroid/provider/BrowserContract$Bookmarks;->CONTENT_URI:Landroid/net/Uri;

    invoke-virtual {v0, v12, v4, v2}, Lcom/android/browser/provider/BrowserProvider2;->insertInTransaction(Landroid/net/Uri;Landroid/content/ContentValues;Z)Landroid/net/Uri;

    move-result-object v4

    .line 1547
    invoke-static {v4}, Landroid/content/ContentUris;->parseId(Landroid/net/Uri;)J

    move-result-wide v12

    const/4 v4, 0x4

    .line 1548
    invoke-interface {v14, v4}, Landroid/database/Cursor;->getInt(I)I

    move-result v4

    if-eqz v4, :cond_7

    .line 1550
    new-instance v4, Landroid/content/ContentValues;

    move-object/from16 v20, v3

    const/4 v3, 0x1

    invoke-direct {v4, v3}, Landroid/content/ContentValues;-><init>(I)V

    .line 1551
    invoke-static {v12, v13}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v12

    invoke-virtual {v4, v15, v12}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    const-string v12, "parent=?"

    new-array v13, v3, [Ljava/lang/String;

    .line 1554
    invoke-static {v8, v9}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v3

    const/16 v21, 0x0

    aput-object v3, v13, v21

    .line 1552
    invoke-virtual {v0, v4, v12, v13, v2}, Lcom/android/browser/provider/BrowserProvider2;->updateBookmarksInTransaction(Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;Z)I

    move-result v3

    add-int v18, v18, v3

    goto :goto_5

    :cond_7
    move-object/from16 v20, v3

    .line 1557
    :goto_5
    sget-object v3, Landroid/provider/BrowserContract$Bookmarks;->CONTENT_URI:Landroid/net/Uri;

    invoke-static {v3, v8, v9}, Landroid/content/ContentUris;->withAppendedId(Landroid/net/Uri;J)Landroid/net/Uri;

    move-result-object v3

    const/4 v4, 0x0

    .line 1558
    invoke-virtual {v0, v3, v4, v4, v2}, Lcom/android/browser/provider/BrowserProvider2;->deleteInTransaction(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;Z)I

    const/4 v3, 0x1

    add-int/lit8 v18, v18, 0x1

    goto :goto_7

    :cond_8
    move-object/from16 v20, v3

    move-object/from16 v7, v19

    const/4 v4, 0x0

    move-object/from16 v19, v13

    :goto_6
    const/4 v3, 0x1

    if-nez v2, :cond_9

    .line 1563
    invoke-interface {v14, v3}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v8

    const-wide/16 v22, 0x1

    add-long v8, v8, v22

    invoke-static {v8, v9}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v8

    invoke-virtual {v1, v12, v8}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    :cond_9
    const-string v8, "bookmarks"

    const-string v9, "_id=?"

    .line 1565
    invoke-virtual {v5, v8, v1, v9, v10}, Landroid/database/sqlite/SQLiteDatabase;->update(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I

    move-result v8

    add-int v18, v18, v8

    :goto_7
    if-eqz v19, :cond_c

    if-nez p3, :cond_a

    const/4 v8, 0x2

    .line 1571
    invoke-interface {v14, v8}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v8

    const-string v9, "url_key"

    move-object/from16 v12, v19

    .line 1572
    invoke-virtual {v12, v9, v8}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_8

    :cond_a
    move-object/from16 v12, v19

    move-object/from16 v8, p2

    .line 1575
    :goto_8
    invoke-static {v8}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v9

    if-nez v9, :cond_b

    const/4 v9, 0x0

    aput-object v8, v10, v9

    const-string v13, "url_key=?"

    move-object/from16 v3, v17

    .line 1577
    invoke-virtual {v5, v3, v12, v13, v10}, Landroid/database/sqlite/SQLiteDatabase;->update(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I

    move-result v13

    if-nez v13, :cond_d

    const-string v13, "favicon"

    .line 1578
    invoke-virtual {v5, v3, v13, v12}, Landroid/database/sqlite/SQLiteDatabase;->insert(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;)J
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_9

    :cond_b
    move-object/from16 v3, v17

    const/4 v9, 0x0

    goto :goto_9

    :cond_c
    move-object/from16 v3, v17

    move-object/from16 v12, v19

    const/4 v9, 0x0

    move-object/from16 v8, p2

    :cond_d
    :goto_9
    move-object/from16 v17, v3

    move-object v4, v8

    move-object v13, v12

    move-object/from16 v3, v20

    const/4 v8, 0x1

    move/from16 v12, p3

    move/from16 v24, v9

    move-object v9, v7

    move/from16 v7, v24

    goto/16 :goto_3

    :cond_e
    if-eqz v14, :cond_f

    .line 1584
    invoke-interface {v14}, Landroid/database/Cursor;->close()V

    :cond_f
    return v18

    :catchall_0
    move-exception v0

    if-eqz v14, :cond_10

    invoke-interface {v14}, Landroid/database/Cursor;->close()V

    .line 1585
    :cond_10
    throw v0
.end method

.method updateHistoryInTransaction(Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I
    .locals 9

    const-string v0, "images"

    .line 1617
    iget-object v1, p0, Lcom/android/browser/provider/BrowserProvider2;->mOpenHelper:Lcom/android/browser/provider/BrowserProvider2$DatabaseHelper;

    invoke-virtual {v1}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v1

    .line 1618
    invoke-direct {p0, p3}, Lcom/android/browser/provider/BrowserProvider2;->filterSearchClient([Ljava/lang/String;)V

    .line 1619
    sget-object v3, Landroid/provider/BrowserContract$History;->CONTENT_URI:Landroid/net/Uri;

    const-string v2, "_id"

    const-string v8, "url"

    filled-new-array {v2, v8}, [Ljava/lang/String;

    move-result-object v4

    const/4 v7, 0x0

    move-object v2, p0

    move-object v5, p2

    move-object v6, p3

    invoke-virtual/range {v2 .. v7}, Lcom/android/browser/provider/BrowserProvider2;->query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p2

    const/4 p3, 0x1

    :try_start_0
    new-array v2, p3, [Ljava/lang/String;

    .line 1625
    invoke-virtual {p1, v8}, Landroid/content/ContentValues;->containsKey(Ljava/lang/String;)Z

    move-result v3

    const/4 v4, 0x0

    if-eqz v3, :cond_0

    .line 1628
    invoke-virtual {p1, v8}, Landroid/content/ContentValues;->getAsString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-direct {p0, v4}, Lcom/android/browser/provider/BrowserProvider2;->filterSearchClient(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 1629
    invoke-virtual {p1, v8, v4}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    .line 1631
    :cond_0
    invoke-virtual {p0, p1, v4}, Lcom/android/browser/provider/BrowserProvider2;->extractImageValues(Landroid/content/ContentValues;Ljava/lang/String;)Landroid/content/ContentValues;

    move-result-object p0

    const/4 v5, 0x0

    move v6, v5

    .line 1633
    :cond_1
    :goto_0
    invoke-interface {p2}, Landroid/database/Cursor;->moveToNext()Z

    move-result v7

    if-eqz v7, :cond_3

    .line 1634
    invoke-interface {p2, v5}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v7

    aput-object v7, v2, v5

    const-string v7, "history"

    const-string v8, "_id=?"

    .line 1635
    invoke-virtual {v1, v7, p1, v8, v2}, Landroid/database/sqlite/SQLiteDatabase;->update(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I

    move-result v7

    add-int/2addr v6, v7

    if-eqz p0, :cond_1

    if-nez v3, :cond_2

    .line 1640
    invoke-interface {p2, p3}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v4

    const-string v7, "url_key"

    .line 1641
    invoke-virtual {p0, v7, v4}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    :cond_2
    aput-object v4, v2, v5

    const-string v7, "url_key=?"

    .line 1644
    invoke-virtual {v1, v0, p0, v7, v2}, Landroid/database/sqlite/SQLiteDatabase;->update(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I

    move-result v7

    if-nez v7, :cond_1

    const-string v7, "favicon"

    .line 1645
    invoke-virtual {v1, v0, v7, p0}, Landroid/database/sqlite/SQLiteDatabase;->insert(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;)J
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    :cond_3
    if-eqz p2, :cond_4

    .line 1650
    invoke-interface {p2}, Landroid/database/Cursor;->close()V

    :cond_4
    return v6

    :catchall_0
    move-exception p0

    if-eqz p2, :cond_5

    invoke-interface {p2}, Landroid/database/Cursor;->close()V

    .line 1651
    :cond_5
    throw p0
.end method

.method public updateInTransaction(Landroid/net/Uri;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;Z)I
    .locals 9

    .line 1300
    sget-object v0, Lcom/android/browser/provider/BrowserProvider2;->URI_MATCHER:Landroid/content/UriMatcher;

    invoke-virtual {v0, p1}, Landroid/content/UriMatcher;->match(Landroid/net/Uri;)I

    move-result v0

    .line 1301
    iget-object v1, p0, Lcom/android/browser/provider/BrowserProvider2;->mOpenHelper:Lcom/android/browser/provider/BrowserProvider2$DatabaseHelper;

    invoke-virtual {v1}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v1

    const/16 v2, 0x7d1

    const/16 v3, 0x7d0

    const/16 v4, 0x3e9

    const/16 v5, 0x3e8

    const/16 v6, 0x2328

    if-eq v0, v6, :cond_0

    const/16 v7, 0x2329

    if-ne v0, v7, :cond_5

    :cond_0
    const-string v7, "bookmark"

    .line 1304
    invoke-virtual {p2, v7}, Landroid/content/ContentValues;->getAsInteger(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v8

    .line 1305
    invoke-virtual {p2, v7}, Landroid/content/ContentValues;->remove(Ljava/lang/String;)V

    if-eqz v8, :cond_3

    .line 1306
    invoke-virtual {v8}, Ljava/lang/Integer;->intValue()I

    move-result v7

    if-nez v7, :cond_1

    goto :goto_1

    :cond_1
    if-ne v0, v6, :cond_2

    move v0, v5

    goto :goto_0

    :cond_2
    move v0, v4

    :goto_0
    const-string v6, "date"

    .line 1318
    invoke-virtual {p2, v6}, Landroid/content/ContentValues;->remove(Ljava/lang/String;)V

    const-string v6, "visits"

    .line 1319
    invoke-virtual {p2, v6}, Landroid/content/ContentValues;->remove(Ljava/lang/String;)V

    const-string v6, "user_entered"

    .line 1320
    invoke-virtual {p2, v6}, Landroid/content/ContentValues;->remove(Ljava/lang/String;)V

    goto :goto_2

    :cond_3
    :goto_1
    if-ne v0, v6, :cond_4

    move v0, v3

    goto :goto_2

    :cond_4
    move v0, v2

    :cond_5
    :goto_2
    const/16 v6, 0xa

    if-eq v0, v6, :cond_13

    const/16 v6, 0xbb8

    if-eq v0, v6, :cond_12

    const/16 v6, 0x1388

    const/4 v7, 0x1

    const/4 v8, 0x0

    if-eq v0, v6, :cond_a

    if-eq v0, v5, :cond_9

    if-eq v0, v4, :cond_8

    if-eq v0, v3, :cond_7

    if-ne v0, v2, :cond_6

    const-string p5, "history._id=?"

    .line 1342
    invoke-static {p3, p5}, Landroid/database/DatabaseUtils;->concatenateWhere(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    new-array p5, v7, [Ljava/lang/String;

    .line 1344
    invoke-static {p1}, Landroid/content/ContentUris;->parseId(Landroid/net/Uri;)J

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v0

    aput-object v0, p5, v8

    .line 1343
    invoke-static {p4, p5}, Landroid/database/DatabaseUtils;->appendSelectionArgs([Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p4

    goto :goto_3

    .line 1396
    :cond_6
    new-instance p0, Ljava/lang/UnsupportedOperationException;

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2}, Ljava/lang/StringBuilder;-><init>()V

    const-string p3, "Unknown update URI "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/UnsupportedOperationException;-><init>(Ljava/lang/String;)V

    throw p0

    .line 1348
    :cond_7
    :goto_3
    invoke-virtual {p0, p2, p3, p4}, Lcom/android/browser/provider/BrowserProvider2;->updateHistoryInTransaction(Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I

    move-result p2

    goto/16 :goto_5

    :cond_8
    const-string v0, "bookmarks._id=?"

    .line 1326
    invoke-static {p3, v0}, Landroid/database/DatabaseUtils;->concatenateWhere(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    new-array v0, v7, [Ljava/lang/String;

    .line 1329
    invoke-static {p1}, Landroid/content/ContentUris;->parseId(Landroid/net/Uri;)J

    move-result-wide v1

    invoke-static {v1, v2}, Ljava/lang/Long;->toString(J)Ljava/lang/String;

    move-result-object v1

    aput-object v1, v0, v8

    .line 1328
    invoke-static {p4, v0}, Landroid/database/DatabaseUtils;->appendSelectionArgs([Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/String;

    move-result-object p4

    .line 1333
    :cond_9
    invoke-virtual {p0, p1, p3, p4}, Lcom/android/browser/provider/BrowserProvider2;->getSelectionWithAccounts(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)[Ljava/lang/Object;

    move-result-object p3

    .line 1334
    aget-object p4, p3, v8

    check-cast p4, Ljava/lang/String;

    .line 1335
    aget-object p3, p3, v7

    check-cast p3, [Ljava/lang/String;

    .line 1336
    invoke-virtual {p0, p2, p4, p3, p5}, Lcom/android/browser/provider/BrowserProvider2;->updateBookmarksInTransaction(Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;Z)I

    move-result p2

    goto :goto_5

    :cond_a
    const-string p1, "url_key"

    .line 1353
    invoke-virtual {p2, p1}, Landroid/content/ContentValues;->getAsString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 1354
    invoke-static {p1}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result p3

    if-nez p3, :cond_11

    .line 1357
    invoke-direct {p0, v1, p1, p2}, Lcom/android/browser/provider/BrowserProvider2;->shouldUpdateImages(Landroid/database/sqlite/SQLiteDatabase;Ljava/lang/String;Landroid/content/ContentValues;)Z

    move-result p3

    if-nez p3, :cond_b

    return v8

    :cond_b
    new-array p3, v7, [Ljava/lang/String;

    aput-object p1, p3, v8

    const-string p4, "images"

    const-string p5, "url_key=?"

    .line 1360
    invoke-virtual {v1, p4, p2, p5, p3}, Landroid/database/sqlite/SQLiteDatabase;->update(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I

    move-result p3

    const-string p5, "favicon"

    if-nez p3, :cond_c

    .line 1363
    invoke-virtual {v1, p4, p5, p2}, Landroid/database/sqlite/SQLiteDatabase;->insertOrThrow(Ljava/lang/String;Ljava/lang/String;Landroid/content/ContentValues;)J

    goto :goto_4

    :cond_c
    move v7, p3

    :goto_4
    const-string p3, "bookmarks"

    .line 1370
    invoke-virtual {p0, v1, p3, p1}, Lcom/android/browser/provider/BrowserProvider2;->getUrlCount(Landroid/database/sqlite/SQLiteDatabase;Ljava/lang/String;Ljava/lang/String;)I

    move-result p3

    if-lez p3, :cond_d

    .line 1371
    sget-object p3, Landroid/provider/BrowserContract$Bookmarks;->CONTENT_URI:Landroid/net/Uri;

    invoke-virtual {p0, p3}, Lcom/android/browser/provider/SQLiteContentProvider;->postNotifyUri(Landroid/net/Uri;)V

    .line 1372
    invoke-virtual {p2, p5}, Landroid/content/ContentValues;->containsKey(Ljava/lang/String;)Z

    move-result v8

    :cond_d
    const-string p3, "history"

    .line 1374
    invoke-virtual {p0, v1, p3, p1}, Lcom/android/browser/provider/BrowserProvider2;->getUrlCount(Landroid/database/sqlite/SQLiteDatabase;Ljava/lang/String;Ljava/lang/String;)I

    move-result p1

    if-lez p1, :cond_e

    .line 1375
    sget-object p1, Landroid/provider/BrowserContract$History;->CONTENT_URI:Landroid/net/Uri;

    invoke-virtual {p0, p1}, Lcom/android/browser/provider/SQLiteContentProvider;->postNotifyUri(Landroid/net/Uri;)V

    .line 1376
    invoke-virtual {p2, p5}, Landroid/content/ContentValues;->containsKey(Ljava/lang/String;)Z

    move-result v8

    .line 1378
    :cond_e
    invoke-virtual {p0}, Lcom/android/browser/provider/BrowserProvider2;->pruneImages()I

    move-result p1

    if-gtz p1, :cond_f

    if-eqz v8, :cond_10

    .line 1379
    :cond_f
    sget-object p1, Lcom/android/browser/provider/BrowserProvider2;->LEGACY_AUTHORITY_URI:Landroid/net/Uri;

    invoke-virtual {p0, p1}, Lcom/android/browser/provider/SQLiteContentProvider;->postNotifyUri(Landroid/net/Uri;)V

    :cond_10
    return v7

    .line 1355
    :cond_11
    new-instance p0, Ljava/lang/IllegalArgumentException;

    const-string p1, "Images.URL is required"

    invoke-direct {p0, p1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_12
    const-string p5, "searches"

    .line 1385
    invoke-virtual {v1, p5, p2, p3, p4}, Landroid/database/sqlite/SQLiteDatabase;->update(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I

    move-result p2

    goto :goto_5

    :cond_13
    const-string p5, "thumbnails"

    .line 1390
    invoke-virtual {v1, p5, p2, p3, p4}, Landroid/database/sqlite/SQLiteDatabase;->update(Ljava/lang/String;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I

    move-result p2

    .line 1399
    :goto_5
    invoke-virtual {p0}, Lcom/android/browser/provider/BrowserProvider2;->pruneImages()I

    if-lez p2, :cond_14

    .line 1401
    invoke-virtual {p0, p1}, Lcom/android/browser/provider/SQLiteContentProvider;->postNotifyUri(Landroid/net/Uri;)V

    .line 1402
    invoke-virtual {p0, p1}, Lcom/android/browser/provider/BrowserProvider2;->shouldNotifyLegacy(Landroid/net/Uri;)Z

    move-result p1

    if-eqz p1, :cond_14

    .line 1403
    sget-object p1, Lcom/android/browser/provider/BrowserProvider2;->LEGACY_AUTHORITY_URI:Landroid/net/Uri;

    invoke-virtual {p0, p1}, Lcom/android/browser/provider/SQLiteContentProvider;->postNotifyUri(Landroid/net/Uri;)V

    :cond_14
    return p2
.end method

.method valuesFromCursor(Landroid/database/Cursor;)Landroid/content/ContentValues;
    .locals 6

    .line 1590
    invoke-interface {p1}, Landroid/database/Cursor;->getColumnCount()I

    move-result p0

    .line 1591
    new-instance v0, Landroid/content/ContentValues;

    invoke-direct {v0, p0}, Landroid/content/ContentValues;-><init>(I)V

    .line 1592
    invoke-interface {p1}, Landroid/database/Cursor;->getColumnNames()[Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x0

    :goto_0
    if-ge v2, p0, :cond_4

    .line 1594
    invoke-interface {p1, v2}, Landroid/database/Cursor;->getType(I)I

    move-result v3

    const/4 v4, 0x1

    if-eq v3, v4, :cond_3

    const/4 v4, 0x2

    if-eq v3, v4, :cond_2

    const/4 v4, 0x3

    if-eq v3, v4, :cond_1

    const/4 v4, 0x4

    if-eq v3, v4, :cond_0

    goto :goto_1

    .line 1596
    :cond_0
    aget-object v3, v1, v2

    invoke-interface {p1, v2}, Landroid/database/Cursor;->getBlob(I)[B

    move-result-object v4

    invoke-virtual {v0, v3, v4}, Landroid/content/ContentValues;->put(Ljava/lang/String;[B)V

    goto :goto_1

    .line 1605
    :cond_1
    aget-object v3, v1, v2

    invoke-interface {p1, v2}, Landroid/database/Cursor;->getString(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v3, v4}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_1

    .line 1599
    :cond_2
    aget-object v3, v1, v2

    invoke-interface {p1, v2}, Landroid/database/Cursor;->getFloat(I)F

    move-result v4

    invoke-static {v4}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v4

    invoke-virtual {v0, v3, v4}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Float;)V

    goto :goto_1

    .line 1602
    :cond_3
    aget-object v3, v1, v2

    invoke-interface {p1, v2}, Landroid/database/Cursor;->getLong(I)J

    move-result-wide v4

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    invoke-virtual {v0, v3, v4}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/Long;)V

    :goto_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_4
    return-object v0
.end method
