.class Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;
.super Ljava/lang/Object;
.source "StaggeredGridLayoutManager.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x8
    name = "LazySpanLookup"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    }
.end annotation


# static fields
.field private static final MIN_SIZE:I = 0xa


# instance fields
.field mData:[I

.field mFullSpanItems:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method constructor <init>()V
    .locals 0

    .line 2120
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private invalidateFullSpansAfter(I)I
    .locals 7
    .param p1, "position"    # I

    .line 2246
    iget-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    const/4 v1, -0x1

    if-nez v0, :cond_0

    .line 2247
    return v1

    .line 2249
    :cond_0
    invoke-virtual {p0, p1}, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->getFullSpanItem(I)Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;

    move-result-object v0

    .line 2250
    .local v0, "item":Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    if-eqz v0, :cond_1

    .line 2251
    iget-object v2, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    invoke-interface {v2, v0}, Ljava/util/List;->remove(Ljava/lang/Object;)Z

    .line 2253
    :cond_1
    const/4 v2, -0x1

    .line 2254
    .local v2, "nextFsiIndex":I
    iget-object v3, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v3

    .line 2255
    .local v3, "count":I
    const/4 v4, 0x0

    .local v4, "i":I
    :goto_0
    if-ge v4, v3, :cond_3

    .line 2256
    iget-object v5, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    invoke-interface {v5, v4}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;

    .line 2257
    .local v5, "fsi":Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    iget v6, v5, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mPosition:I

    if-lt v6, p1, :cond_2

    .line 2258
    move v2, v4

    .line 2259
    goto :goto_1

    .line 2255
    .end local v5    # "fsi":Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    :cond_2
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 2262
    .end local v4    # "i":I
    :cond_3
    :goto_1
    if-eq v2, v1, :cond_4

    .line 2263
    iget-object v1, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    invoke-interface {v1, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;

    .line 2264
    .local v1, "fsi":Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    iget-object v4, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    invoke-interface {v4, v2}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    .line 2265
    iget v4, v1, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mPosition:I

    return v4

    .line 2267
    .end local v1    # "fsi":Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    :cond_4
    return v1
.end method

.method private offsetFullSpansForAddition(II)V
    .locals 3
    .param p1, "positionStart"    # I
    .param p2, "itemCount"    # I

    .line 2233
    iget-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    if-nez v0, :cond_0

    .line 2234
    return-void

    .line 2236
    :cond_0
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    .local v0, "i":I
    :goto_0
    if-ltz v0, :cond_2

    .line 2237
    iget-object v1, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    invoke-interface {v1, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;

    .line 2238
    .local v1, "fsi":Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    iget v2, v1, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mPosition:I

    if-ge v2, p1, :cond_1

    .line 2239
    goto :goto_1

    .line 2241
    :cond_1
    iget v2, v1, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mPosition:I

    add-int/2addr v2, p2

    iput v2, v1, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mPosition:I

    .line 2236
    .end local v1    # "fsi":Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    :goto_1
    add-int/lit8 v0, v0, -0x1

    goto :goto_0

    .line 2243
    .end local v0    # "i":I
    :cond_2
    return-void
.end method

.method private offsetFullSpansForRemoval(II)V
    .locals 4
    .param p1, "positionStart"    # I
    .param p2, "itemCount"    # I

    .line 2205
    iget-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    if-nez v0, :cond_0

    .line 2206
    return-void

    .line 2208
    :cond_0
    add-int v1, p1, p2

    .line 2209
    .local v1, "end":I
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    .local v0, "i":I
    :goto_0
    if-ltz v0, :cond_3

    .line 2210
    iget-object v2, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    invoke-interface {v2, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;

    .line 2211
    .local v2, "fsi":Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    iget v3, v2, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mPosition:I

    if-ge v3, p1, :cond_1

    .line 2212
    goto :goto_1

    .line 2214
    :cond_1
    iget v3, v2, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mPosition:I

    if-ge v3, v1, :cond_2

    .line 2215
    iget-object v3, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    invoke-interface {v3, v0}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    goto :goto_1

    .line 2217
    :cond_2
    iget v3, v2, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mPosition:I

    sub-int/2addr v3, p2

    iput v3, v2, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mPosition:I

    .line 2209
    .end local v2    # "fsi":Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    :goto_1
    add-int/lit8 v0, v0, -0x1

    goto :goto_0

    .line 2220
    .end local v0    # "i":I
    :cond_3
    return-void
.end method


# virtual methods
.method public addFullSpanItem(Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;)V
    .locals 5
    .param p1, "fullSpanItem"    # Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;

    .line 2271
    iget-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    if-nez v0, :cond_0

    .line 2272
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    .line 2274
    :cond_0
    iget-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    .line 2275
    .local v0, "size":I
    const/4 v1, 0x0

    .local v1, "i":I
    :goto_0
    if-ge v1, v0, :cond_3

    .line 2276
    iget-object v2, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    invoke-interface {v2, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;

    .line 2277
    .local v2, "other":Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    iget v3, v2, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mPosition:I

    iget v4, p1, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mPosition:I

    if-ne v3, v4, :cond_1

    .line 2281
    iget-object v3, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    invoke-interface {v3, v1}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    .line 2284
    :cond_1
    iget v3, v2, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mPosition:I

    iget v4, p1, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mPosition:I

    if-lt v3, v4, :cond_2

    .line 2285
    iget-object v3, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    invoke-interface {v3, v1, p1}, Ljava/util/List;->add(ILjava/lang/Object;)V

    .line 2286
    return-void

    .line 2275
    .end local v2    # "other":Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    :cond_2
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 2289
    .end local v1    # "i":I
    :cond_3
    iget-object v1, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    invoke-interface {v1, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 2290
    return-void
.end method

.method clear()V
    .locals 2

    .line 2188
    iget-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mData:[I

    if-eqz v0, :cond_0

    .line 2189
    const/4 v1, -0x1

    invoke-static {v0, v1}, Ljava/util/Arrays;->fill([II)V

    .line 2191
    :cond_0
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    .line 2192
    return-void
.end method

.method ensureSize(I)V
    .locals 5
    .param p1, "position"    # I

    .line 2176
    iget-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mData:[I

    const/4 v1, -0x1

    if-nez v0, :cond_0

    .line 2177
    const/16 v0, 0xa

    invoke-static {p1, v0}, Ljava/lang/Math;->max(II)I

    move-result v0

    add-int/lit8 v0, v0, 0x1

    new-array v0, v0, [I

    iput-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mData:[I

    .line 2178
    invoke-static {v0, v1}, Ljava/util/Arrays;->fill([II)V

    goto :goto_0

    .line 2179
    :cond_0
    array-length v0, v0

    if-lt p1, v0, :cond_1

    .line 2180
    iget-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mData:[I

    .line 2181
    .local v0, "old":[I
    invoke-virtual {p0, p1}, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->sizeForPosition(I)I

    move-result v2

    new-array v2, v2, [I

    iput-object v2, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mData:[I

    .line 2182
    array-length v3, v0

    const/4 v4, 0x0

    invoke-static {v0, v4, v2, v4, v3}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 2183
    iget-object v2, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mData:[I

    array-length v3, v0

    array-length v4, v2

    invoke-static {v2, v3, v4, v1}, Ljava/util/Arrays;->fill([IIII)V

    .line 2185
    .end local v0    # "old":[I
    :cond_1
    :goto_0
    return-void
.end method

.method forceInvalidateAfter(I)I
    .locals 3
    .param p1, "position"    # I

    .line 2126
    iget-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    if-eqz v0, :cond_1

    .line 2127
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    .local v0, "i":I
    :goto_0
    if-ltz v0, :cond_1

    .line 2128
    iget-object v1, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    invoke-interface {v1, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;

    .line 2129
    .local v1, "fsi":Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    iget v2, v1, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mPosition:I

    if-lt v2, p1, :cond_0

    .line 2130
    iget-object v2, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    invoke-interface {v2, v0}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    .line 2127
    .end local v1    # "fsi":Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    :cond_0
    add-int/lit8 v0, v0, -0x1

    goto :goto_0

    .line 2134
    .end local v0    # "i":I
    :cond_1
    invoke-virtual {p0, p1}, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->invalidateAfter(I)I

    move-result v0

    return v0
.end method

.method public getFirstFullSpanItemInRange(IIIZ)Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    .locals 5
    .param p1, "minPos"    # I
    .param p2, "maxPos"    # I
    .param p3, "gapDir"    # I
    .param p4, "hasUnwantedGapAfter"    # Z

    .line 2306
    iget-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 2307
    return-object v1

    .line 2309
    :cond_0
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    .line 2310
    .local v0, "limit":I
    const/4 v2, 0x0

    .local v2, "i":I
    :goto_0
    if-ge v2, v0, :cond_4

    .line 2311
    iget-object v3, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    invoke-interface {v3, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;

    .line 2312
    .local v3, "fsi":Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    iget v4, v3, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mPosition:I

    if-lt v4, p2, :cond_1

    .line 2313
    return-object v1

    .line 2315
    :cond_1
    iget v4, v3, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mPosition:I

    if-lt v4, p1, :cond_3

    if-eqz p3, :cond_2

    iget v4, v3, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mGapDir:I

    if-eq v4, p3, :cond_2

    if-eqz p4, :cond_3

    iget-boolean v4, v3, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mHasUnwantedGapAfter:Z

    if-eqz v4, :cond_3

    .line 2316
    :cond_2
    return-object v3

    .line 2310
    .end local v3    # "fsi":Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    :cond_3
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 2319
    .end local v2    # "i":I
    :cond_4
    return-object v1
.end method

.method public getFullSpanItem(I)Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    .locals 4
    .param p1, "position"    # I

    .line 2293
    iget-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 2294
    return-object v1

    .line 2296
    :cond_0
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    .local v0, "i":I
    :goto_0
    if-ltz v0, :cond_2

    .line 2297
    iget-object v2, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mFullSpanItems:Ljava/util/List;

    invoke-interface {v2, v0}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;

    .line 2298
    .local v2, "fsi":Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    iget v3, v2, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;->mPosition:I

    if-ne v3, p1, :cond_1

    .line 2299
    return-object v2

    .line 2296
    .end local v2    # "fsi":Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup$FullSpanItem;
    :cond_1
    add-int/lit8 v0, v0, -0x1

    goto :goto_0

    .line 2302
    .end local v0    # "i":I
    :cond_2
    return-object v1
.end method

.method getSpan(I)I
    .locals 2
    .param p1, "position"    # I

    .line 2155
    iget-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mData:[I

    if-eqz v0, :cond_1

    array-length v1, v0

    if-lt p1, v1, :cond_0

    goto :goto_0

    .line 2158
    :cond_0
    aget v0, v0, p1

    return v0

    .line 2156
    :cond_1
    :goto_0
    const/4 v0, -0x1

    return v0
.end method

.method invalidateAfter(I)I
    .locals 4
    .param p1, "position"    # I

    .line 2138
    iget-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mData:[I

    const/4 v1, -0x1

    if-nez v0, :cond_0

    .line 2139
    return v1

    .line 2141
    :cond_0
    array-length v0, v0

    if-lt p1, v0, :cond_1

    .line 2142
    return v1

    .line 2144
    :cond_1
    invoke-direct {p0, p1}, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->invalidateFullSpansAfter(I)I

    move-result v0

    .line 2145
    .local v0, "endPosition":I
    if-ne v0, v1, :cond_2

    .line 2146
    iget-object v2, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mData:[I

    array-length v3, v2

    invoke-static {v2, p1, v3, v1}, Ljava/util/Arrays;->fill([IIII)V

    .line 2147
    iget-object v1, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mData:[I

    array-length v1, v1

    return v1

    .line 2149
    :cond_2
    iget-object v2, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mData:[I

    add-int/lit8 v3, v0, 0x1

    invoke-static {v2, p1, v3, v1}, Ljava/util/Arrays;->fill([IIII)V

    .line 2150
    add-int/lit8 v1, v0, 0x1

    return v1
.end method

.method offsetForAddition(II)V
    .locals 3
    .param p1, "positionStart"    # I
    .param p2, "itemCount"    # I

    .line 2223
    iget-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mData:[I

    if-eqz v0, :cond_1

    array-length v0, v0

    if-lt p1, v0, :cond_0

    goto :goto_0

    .line 2226
    :cond_0
    add-int v0, p1, p2

    invoke-virtual {p0, v0}, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->ensureSize(I)V

    .line 2227
    iget-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mData:[I

    add-int v1, p1, p2

    array-length v2, v0

    sub-int/2addr v2, p1

    sub-int/2addr v2, p2

    invoke-static {v0, p1, v0, v1, v2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 2228
    iget-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mData:[I

    add-int v1, p1, p2

    const/4 v2, -0x1

    invoke-static {v0, p1, v1, v2}, Ljava/util/Arrays;->fill([IIII)V

    .line 2229
    invoke-direct {p0, p1, p2}, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->offsetFullSpansForAddition(II)V

    .line 2230
    return-void

    .line 2224
    :cond_1
    :goto_0
    return-void
.end method

.method offsetForRemoval(II)V
    .locals 4
    .param p1, "positionStart"    # I
    .param p2, "itemCount"    # I

    .line 2195
    iget-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mData:[I

    if-eqz v0, :cond_1

    array-length v0, v0

    if-lt p1, v0, :cond_0

    goto :goto_0

    .line 2198
    :cond_0
    add-int v0, p1, p2

    invoke-virtual {p0, v0}, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->ensureSize(I)V

    .line 2199
    iget-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mData:[I

    add-int v1, p1, p2

    array-length v2, v0

    sub-int/2addr v2, p1

    sub-int/2addr v2, p2

    invoke-static {v0, v1, v0, p1, v2}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 2200
    iget-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mData:[I

    array-length v1, v0

    sub-int/2addr v1, p2

    array-length v2, v0

    const/4 v3, -0x1

    invoke-static {v0, v1, v2, v3}, Ljava/util/Arrays;->fill([IIII)V

    .line 2201
    invoke-direct {p0, p1, p2}, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->offsetFullSpansForRemoval(II)V

    .line 2202
    return-void

    .line 2196
    :cond_1
    :goto_0
    return-void
.end method

.method setSpan(ILcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$Span;)V
    .locals 2
    .param p1, "position"    # I
    .param p2, "span"    # Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$Span;

    .line 2163
    invoke-virtual {p0, p1}, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->ensureSize(I)V

    .line 2164
    iget-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mData:[I

    iget v1, p2, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$Span;->mIndex:I

    aput v1, v0, p1

    .line 2165
    return-void
.end method

.method sizeForPosition(I)I
    .locals 1
    .param p1, "position"    # I

    .line 2168
    iget-object v0, p0, Lcom/samsung/android/ui/recyclerview/widget/StaggeredGridLayoutManager$LazySpanLookup;->mData:[I

    array-length v0, v0

    .line 2169
    .local v0, "len":I
    :goto_0
    if-gt v0, p1, :cond_0

    .line 2170
    mul-int/lit8 v0, v0, 0x2

    goto :goto_0

    .line 2172
    :cond_0
    return v0
.end method
