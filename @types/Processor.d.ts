interface HashData {
    id: number;
    mime: string;
    size: number;
    name: string;
    type: HashImageType;
    v?: number;
    width?: number;
    height?: number;
    quality?: number;
    format?: string;
    manga_entity_cover?: number;
    manga_entity_banner?: number;
    chapter_entity_page?: number;
    user_entity_avatar?: number;
    user_entity_banner?: number;
    scan_entity_icon?: number;
    scan_entity_banner?: number;
}

type HashImageType =
    | 'MANGA_COVER'
    | 'MANGA_BANNER'
    | 'CHAPTER_PAGE'
    | 'USER_AVATAR'
    | 'USER_BANNER'
    | 'SCAN_ICON'
    | 'SCAN_BANNER';
