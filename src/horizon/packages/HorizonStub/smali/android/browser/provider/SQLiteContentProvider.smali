.class public abstract Lcom/android/browser/provider/SQLiteContentProvider;
.super Landroid/content/ContentProvider;
.source "SQLiteContentProvider.java"


# instance fields
.field private final mApplyingBatch:Ljava/lang/ThreadLocal;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/ThreadLocal<",
            "Ljava/lang/Boolean;",
            ">;"
        }
    .end annotation
.end field

.field private mChangedUris:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Landroid/net/Uri;",
            ">;"
        }
    .end annotation
.end field

.field protected mDb:Landroid/database/sqlite/SQLiteDatabase;

.field private mOpenHelper:Landroid/database/sqlite/SQLiteOpenHelper;


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 37
    invoke-direct {p0}, Landroid/content/ContentProvider;-><init>()V

    .line 45
    new-instance v0, Ljava/lang/ThreadLocal;

    invoke-direct {v0}, Ljava/lang/ThreadLocal;-><init>()V

    iput-object v0, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mApplyingBatch:Ljava/lang/ThreadLocal;

    return-void
.end method

.method private applyingBatch()Z
    .locals 1

    .line 103
    iget-object v0, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mApplyingBatch:Ljava/lang/ThreadLocal;

    invoke-virtual {v0}, Ljava/lang/ThreadLocal;->get()Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_0

    iget-object p0, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mApplyingBatch:Ljava/lang/ThreadLocal;

    invoke-virtual {p0}, Ljava/lang/ThreadLocal;->get()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Boolean;

    invoke-virtual {p0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p0

    if-eqz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method


# virtual methods
.method public applyBatch(Ljava/util/ArrayList;)[Landroid/content/ContentProviderResult;
    .locals 12
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/ArrayList<",
            "Landroid/content/ContentProviderOperation;",
            ">;)[",
            "Landroid/content/ContentProviderResult;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Landroid/content/OperationApplicationException;
        }
    .end annotation

    .line 197
    sget-object v0, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    .line 200
    iget-object v1, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mOpenHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v1}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v1

    iput-object v1, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mDb:Landroid/database/sqlite/SQLiteDatabase;

    .line 201
    invoke-virtual {v1}, Landroid/database/sqlite/SQLiteDatabase;->beginTransaction()V

    const/4 v1, 0x0

    .line 203
    :try_start_0
    iget-object v2, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mApplyingBatch:Ljava/lang/ThreadLocal;

    sget-object v3, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {v2, v3}, Ljava/lang/ThreadLocal;->set(Ljava/lang/Object;)V

    .line 204
    invoke-virtual {p1}, Ljava/util/ArrayList;->size()I

    move-result v2

    .line 205
    new-array v3, v2, [Landroid/content/ContentProviderResult;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    move v4, v1

    move v5, v4

    move v6, v5

    move v7, v6

    :goto_0
    if-ge v4, v2, :cond_4

    const/4 v8, 0x1

    add-int/2addr v5, v8

    const/16 v9, 0x1f4

    if-ge v5, v9, :cond_3

    .line 213
    :try_start_1
    invoke-virtual {p1, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Landroid/content/ContentProviderOperation;

    if-nez v6, :cond_0

    .line 214
    invoke-virtual {v9}, Landroid/content/ContentProviderOperation;->getUri()Landroid/net/Uri;

    move-result-object v10

    invoke-virtual {p0, v10}, Lcom/android/browser/provider/SQLiteContentProvider;->isCallerSyncAdapter(Landroid/net/Uri;)Z

    move-result v10

    if-eqz v10, :cond_0

    move v6, v8

    :cond_0
    if-lez v4, :cond_2

    .line 217
    invoke-virtual {v9}, Landroid/content/ContentProviderOperation;->isYieldAllowed()Z

    move-result v8

    if-eqz v8, :cond_2

    .line 219
    iget-object v5, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mDb:Landroid/database/sqlite/SQLiteDatabase;

    const-wide/16 v10, 0xfa0

    invoke-virtual {v5, v10, v11}, Landroid/database/sqlite/SQLiteDatabase;->yieldIfContendedSafely(J)Z

    move-result v5

    if-eqz v5, :cond_1

    add-int/lit8 v7, v7, 0x1

    :cond_1
    move v5, v1

    .line 223
    :cond_2
    invoke-virtual {v9, p0, v3, v4}, Landroid/content/ContentProviderOperation;->apply(Landroid/content/ContentProvider;[Landroid/content/ContentProviderResult;I)Landroid/content/ContentProviderResult;

    move-result-object v8

    aput-object v8, v3, v4

    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 208
    :cond_3
    new-instance p1, Landroid/content/OperationApplicationException;

    const-string v1, "Too many content provider operations between yield points. The maximum number of operations per yield point is 500"

    invoke-direct {p1, v1, v7}, Landroid/content/OperationApplicationException;-><init>(Ljava/lang/String;I)V

    throw p1

    .line 225
    :cond_4
    iget-object p1, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mDb:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {p1}, Landroid/database/sqlite/SQLiteDatabase;->setTransactionSuccessful()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 228
    iget-object p1, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mApplyingBatch:Ljava/lang/ThreadLocal;

    invoke-virtual {p1, v0}, Ljava/lang/ThreadLocal;->set(Ljava/lang/Object;)V

    .line 229
    iget-object p1, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mDb:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {p1}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V

    .line 230
    invoke-virtual {p0, v6}, Lcom/android/browser/provider/SQLiteContentProvider;->onEndTransaction(Z)V

    return-object v3

    :catchall_0
    move-exception p1

    move v1, v6

    goto :goto_1

    :catchall_1
    move-exception p1

    .line 228
    :goto_1
    iget-object v2, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mApplyingBatch:Ljava/lang/ThreadLocal;

    invoke-virtual {v2, v0}, Ljava/lang/ThreadLocal;->set(Ljava/lang/Object;)V

    .line 229
    iget-object v0, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mDb:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V

    .line 230
    invoke-virtual {p0, v1}, Lcom/android/browser/provider/SQLiteContentProvider;->onEndTransaction(Z)V

    .line 231
    throw p1
.end method

.method public bulkInsert(Landroid/net/Uri;[Landroid/content/ContentValues;)I
    .locals 4

    .line 130
    array-length v0, p2

    .line 131
    invoke-virtual {p0, p1}, Lcom/android/browser/provider/SQLiteContentProvider;->isCallerSyncAdapter(Landroid/net/Uri;)Z

    move-result v1

    .line 132
    iget-object v2, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mOpenHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v2}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v2

    iput-object v2, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mDb:Landroid/database/sqlite/SQLiteDatabase;

    .line 133
    invoke-virtual {v2}, Landroid/database/sqlite/SQLiteDatabase;->beginTransaction()V

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v0, :cond_0

    .line 136
    :try_start_0
    aget-object v3, p2, v2

    invoke-virtual {p0, p1, v3, v1}, Lcom/android/browser/provider/SQLiteContentProvider;->insertInTransaction(Landroid/net/Uri;Landroid/content/ContentValues;Z)Landroid/net/Uri;

    .line 137
    iget-object v3, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mDb:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {v3}, Landroid/database/sqlite/SQLiteDatabase;->yieldIfContendedSafely()Z

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 139
    :cond_0
    iget-object p1, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mDb:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {p1}, Landroid/database/sqlite/SQLiteDatabase;->setTransactionSuccessful()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 141
    iget-object p1, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mDb:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {p1}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V

    .line 144
    invoke-virtual {p0, v1}, Lcom/android/browser/provider/SQLiteContentProvider;->onEndTransaction(Z)V

    return v0

    :catchall_0
    move-exception p1

    .line 141
    iget-object p0, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mDb:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {p0}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V

    .line 142
    throw p1
.end method

.method public delete(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)I
    .locals 2

    .line 175
    invoke-virtual {p0, p1}, Lcom/android/browser/provider/SQLiteContentProvider;->isCallerSyncAdapter(Landroid/net/Uri;)Z

    move-result v0

    .line 176
    invoke-direct {p0}, Lcom/android/browser/provider/SQLiteContentProvider;->applyingBatch()Z

    move-result v1

    if-nez v1, :cond_0

    .line 178
    iget-object v1, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mOpenHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v1}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v1

    iput-object v1, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mDb:Landroid/database/sqlite/SQLiteDatabase;

    .line 179
    invoke-virtual {v1}, Landroid/database/sqlite/SQLiteDatabase;->beginTransaction()V

    .line 181
    :try_start_0
    invoke-virtual {p0, p1, p2, p3, v0}, Lcom/android/browser/provider/SQLiteContentProvider;->deleteInTransaction(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;Z)I

    move-result p1

    .line 182
    iget-object p2, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mDb:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {p2}, Landroid/database/sqlite/SQLiteDatabase;->setTransactionSuccessful()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 184
    iget-object p2, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mDb:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {p2}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V

    .line 187
    invoke-virtual {p0, v0}, Lcom/android/browser/provider/SQLiteContentProvider;->onEndTransaction(Z)V

    goto :goto_0

    :catchall_0
    move-exception p1

    .line 184
    iget-object p0, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mDb:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {p0}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V

    .line 185
    throw p1

    .line 189
    :cond_0
    invoke-virtual {p0, p1, p2, p3, v0}, Lcom/android/browser/provider/SQLiteContentProvider;->deleteInTransaction(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;Z)I

    move-result p1

    :goto_0
    return p1
.end method

.method public abstract deleteInTransaction(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;Z)I
.end method

.method public abstract getDatabaseHelper(Landroid/content/Context;)Landroid/database/sqlite/SQLiteOpenHelper;
.end method

.method public insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;
    .locals 2

    .line 109
    invoke-virtual {p0, p1}, Lcom/android/browser/provider/SQLiteContentProvider;->isCallerSyncAdapter(Landroid/net/Uri;)Z

    move-result v0

    .line 110
    invoke-direct {p0}, Lcom/android/browser/provider/SQLiteContentProvider;->applyingBatch()Z

    move-result v1

    if-nez v1, :cond_0

    .line 112
    iget-object v1, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mOpenHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v1}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v1

    iput-object v1, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mDb:Landroid/database/sqlite/SQLiteDatabase;

    .line 113
    invoke-virtual {v1}, Landroid/database/sqlite/SQLiteDatabase;->beginTransaction()V

    .line 115
    :try_start_0
    invoke-virtual {p0, p1, p2, v0}, Lcom/android/browser/provider/SQLiteContentProvider;->insertInTransaction(Landroid/net/Uri;Landroid/content/ContentValues;Z)Landroid/net/Uri;

    move-result-object p1

    .line 116
    iget-object p2, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mDb:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {p2}, Landroid/database/sqlite/SQLiteDatabase;->setTransactionSuccessful()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 118
    iget-object p2, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mDb:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {p2}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V

    .line 121
    invoke-virtual {p0, v0}, Lcom/android/browser/provider/SQLiteContentProvider;->onEndTransaction(Z)V

    goto :goto_0

    :catchall_0
    move-exception p1

    .line 118
    iget-object p0, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mDb:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {p0}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V

    .line 119
    throw p1

    .line 123
    :cond_0
    invoke-virtual {p0, p1, p2, v0}, Lcom/android/browser/provider/SQLiteContentProvider;->insertInTransaction(Landroid/net/Uri;Landroid/content/ContentValues;Z)Landroid/net/Uri;

    move-result-object p1

    :goto_0
    return-object p1
.end method

.method public abstract insertInTransaction(Landroid/net/Uri;Landroid/content/ContentValues;Z)Landroid/net/Uri;
.end method

.method public abstract isCallerSyncAdapter(Landroid/net/Uri;)Z
.end method

.method public onCreate()Z
    .locals 1

    .line 55
    invoke-virtual {p0}, Landroid/content/ContentProvider;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 56
    invoke-virtual {p0, v0}, Lcom/android/browser/provider/SQLiteContentProvider;->getDatabaseHelper(Landroid/content/Context;)Landroid/database/sqlite/SQLiteOpenHelper;

    move-result-object v0

    iput-object v0, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mOpenHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    .line 57
    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    iput-object v0, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mChangedUris:Ljava/util/Set;

    const/4 p0, 0x1

    return p0
.end method

.method protected onEndTransaction(Z)V
    .locals 5

    .line 236
    iget-object v0, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mChangedUris:Ljava/util/Set;

    monitor-enter v0

    .line 237
    :try_start_0
    new-instance v1, Ljava/util/HashSet;

    iget-object v2, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mChangedUris:Ljava/util/Set;

    invoke-direct {v1, v2}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V

    .line 238
    iget-object v2, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mChangedUris:Ljava/util/Set;

    invoke-interface {v2}, Ljava/util/Set;->clear()V

    .line 239
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 240
    invoke-virtual {p0}, Landroid/content/ContentProvider;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    .line 241
    invoke-interface {v1}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/net/Uri;

    if-nez p1, :cond_0

    .line 242
    invoke-virtual {p0, v2}, Lcom/android/browser/provider/SQLiteContentProvider;->syncToNetwork(Landroid/net/Uri;)Z

    move-result v3

    if-eqz v3, :cond_0

    const/4 v3, 0x1

    goto :goto_1

    :cond_0
    const/4 v3, 0x0

    :goto_1
    const/4 v4, 0x0

    .line 243
    invoke-virtual {v0, v2, v4, v3}, Landroid/content/ContentResolver;->notifyChange(Landroid/net/Uri;Landroid/database/ContentObserver;Z)V

    goto :goto_0

    :cond_1
    return-void

    :catchall_0
    move-exception p0

    .line 239
    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method protected postNotifyUri(Landroid/net/Uri;)V
    .locals 1

    .line 89
    iget-object v0, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mChangedUris:Ljava/util/Set;

    monitor-enter v0

    .line 90
    :try_start_0
    iget-object p0, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mChangedUris:Ljava/util/Set;

    invoke-interface {p0, p1}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 91
    monitor-exit v0

    return-void

    :catchall_0
    move-exception p0

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw p0
.end method

.method protected abstract syncToNetwork(Landroid/net/Uri;)Z
.end method

.method public update(Landroid/net/Uri;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I
    .locals 7

    .line 151
    invoke-virtual {p0, p1}, Lcom/android/browser/provider/SQLiteContentProvider;->isCallerSyncAdapter(Landroid/net/Uri;)Z

    move-result v6

    .line 152
    invoke-direct {p0}, Lcom/android/browser/provider/SQLiteContentProvider;->applyingBatch()Z

    move-result v0

    if-nez v0, :cond_0

    .line 154
    iget-object v0, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mOpenHelper:Landroid/database/sqlite/SQLiteOpenHelper;

    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteOpenHelper;->getWritableDatabase()Landroid/database/sqlite/SQLiteDatabase;

    move-result-object v0

    iput-object v0, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mDb:Landroid/database/sqlite/SQLiteDatabase;

    .line 155
    invoke-virtual {v0}, Landroid/database/sqlite/SQLiteDatabase;->beginTransaction()V

    move-object v0, p0

    move-object v1, p1

    move-object v2, p2

    move-object v3, p3

    move-object v4, p4

    move v5, v6

    .line 157
    :try_start_0
    invoke-virtual/range {v0 .. v5}, Lcom/android/browser/provider/SQLiteContentProvider;->updateInTransaction(Landroid/net/Uri;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;Z)I

    move-result p1

    .line 159
    iget-object p2, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mDb:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {p2}, Landroid/database/sqlite/SQLiteDatabase;->setTransactionSuccessful()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 161
    iget-object p2, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mDb:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {p2}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V

    .line 164
    invoke-virtual {p0, v6}, Lcom/android/browser/provider/SQLiteContentProvider;->onEndTransaction(Z)V

    goto :goto_0

    :catchall_0
    move-exception p1

    .line 161
    iget-object p0, p0, Lcom/android/browser/provider/SQLiteContentProvider;->mDb:Landroid/database/sqlite/SQLiteDatabase;

    invoke-virtual {p0}, Landroid/database/sqlite/SQLiteDatabase;->endTransaction()V

    .line 162
    throw p1

    :cond_0
    move-object v0, p0

    move-object v1, p1

    move-object v2, p2

    move-object v3, p3

    move-object v4, p4

    move v5, v6

    .line 166
    invoke-virtual/range {v0 .. v5}, Lcom/android/browser/provider/SQLiteContentProvider;->updateInTransaction(Landroid/net/Uri;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;Z)I

    move-result p1

    :goto_0
    return p1
.end method

.method public abstract updateInTransaction(Landroid/net/Uri;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;Z)I
.end method
